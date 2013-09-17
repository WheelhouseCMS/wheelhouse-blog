class Blog::CommentsController < Wheelhouse::ResourceController
  belongs_to :post, :class_name => Blog::Post
  defaults :resource_class => Blog::Comment
  
  actions :destroy
  
protected
  def resource
    @comment ||= parent.find_comment(params[:id])
  end

  def destroy_resource(comment)
    parent.delete_comment(comment)
  end
end
