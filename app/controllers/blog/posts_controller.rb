class Blog::PostsController < Wheelhouse::ResourceController
  belongs_to :blog, :class_name => Blog::Blog
  defaults :resource_class => Blog::Post, :collection_name => :all_posts

  manage_site_breadcrumb
  breadcrumb { [parent.label, blog_path(parent)] }
  
protected
  def update_resource(object, attributes)
    super(object, attributes.reverse_merge(:categories => []))
  end
end
