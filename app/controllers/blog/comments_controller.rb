class Blog::CommentsController < Wheelhouse::ResourceController
  belongs_to :post, :class_name => Blog::Post
  defaults :resource_class => Blog::Comment, :collection_name => :all_comments, :finder => :find_by_id
  
  actions :destroy
  
  def moderate
    parent.all_comments.moderate(resource, params[:approved])
    head :ok
  end
  
protected
  def destroy_resource(comment)
    parent.all_comments.destroy(comment)
  end
end
