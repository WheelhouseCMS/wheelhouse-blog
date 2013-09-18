class Blog::CommentCollection < MongoModel::Collection[Blog::Comment]
  delegate :comments_enabled?, :moderation_required?, :clear_cache!, :to => :post
  
  def approved
    scope { |comment| comment.approved? }

  end
  
  def unmoderated
    scope { |comment| !comment.approved? }
  end
  
  def find_by_id(id)
    find { |comment| comment.id == id } || raise(MongoModel::DocumentNotFound)
  end
  
  def submit(comment)
    return unless comments_enabled?
    
    comment.posted_at = Time.now
    comment.approved = !moderation_required?
    
    if comment.valid?
      self << comment
      post.push!(:comments => comment.to_mongo)
      clear_cache!
    end
  end
  
  def destroy(comment)
    delete(comment)
    post.pull!(:comments => { "_id" => comment.id.to_mongo })
    clear_cache!
  end
  
  def moderate(comment, approved)
    comment.approved = approved
    comment_scope(comment).set!("comments.$.approved" => comment.approved)
    clear_cache!
  end

private
  def post
    raise 'Parent post is required' unless parent_document
    parent_document
  end
  
  def comment_scope(comment)
    Blog::Post.where(:id => post.id, "comments._id" => comment.id.to_mongo)
  end
  
  def scope(&block)
    scoped = self.class.new(select(&block))
    scoped.parent_document = parent_document
    scoped
  end
end
