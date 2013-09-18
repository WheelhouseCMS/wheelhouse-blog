class Blog::CommentCollection < MongoModel::Collection[Blog::Comment]
  def find(id)
    super { |comment| comment.id == id }
  end
  
  def submit(comment)
    comment.posted_at = Time.now
    
    if comment.valid?
      self << comment
      post.push!(:comments => comment.to_mongo)
      post.clear_cache!
    end
  end
  
  def destroy(comment)
    delete(comment)
    post.pull!(:comments => { "_id" => comment.id.to_mongo })
    post.clear_cache!
  end

private
  def post
    raise 'Parent post is required' unless parent_document
    parent_document
  end
end
