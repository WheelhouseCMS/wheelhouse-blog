require "wheelhouse"

module Blog
  class Plugin < Wheelhouse::Plugin
    resources do
      Blog.select(:id, :label).map do |blog|
        [ Post, blog.label, lambda { new_blog_blog_post_path(blog.id) } ]
      end
    end
    
    resource { Blog }
  end
end
