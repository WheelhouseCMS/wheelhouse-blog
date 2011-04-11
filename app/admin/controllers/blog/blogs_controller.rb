class Blog::BlogsController < Wheelhouse::ResourceController
  self.resource_class = Blog::Blog
  breadcrumb { ["Site Overview", wheelhouse_site_url] }
end
