class Blog::PostsController < Wheelhouse::ResourceController
  belongs_to :blog, :class_name => Blog::Blog
  defaults :resource_class => Blog::Post, :collection_name => :all_posts

  breadcrumb { ["Site Overview", wheelhouse_site_url] }
  breadcrumb { [parent.label, blog_blog_path(parent)] }
  
protected
  def update_resource(object, attributes)
    super(object, attributes.reverse_merge(:categories => []))
  end
end
