class Blog::BlogsController < Wheelhouse::ResourceController
  self.resource_class = Blog::Blog
  manage_site_breadcrumb
end
