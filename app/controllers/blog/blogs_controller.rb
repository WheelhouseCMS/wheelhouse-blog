class Blog::BlogsController < Wheelhouse::ResourceController
  self.resource_class = Blog::Blog
  manage_site_breadcrumb

  def section
    Blog::Plugin.config.wheelhouse.blog.sections ? @blog.label : super
  end
end
