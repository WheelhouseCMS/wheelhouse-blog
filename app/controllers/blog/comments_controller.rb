class Blog::CommentsController < Wheelhouse::ResourceController
  belongs_to :post, :class_name => Blog::Post
  defaults :resource_class => Blog::Comment
  
  actions :destroy
  
protected
  def destroy_resource(comment)
    parent.comments.destroy(comment)
  end
end
