require "wheelhouse"

module Blog
  class Plugin < Wheelhouse::Plugin
    config.wheelhouse.blog = ActiveSupport::OrderedOptions.new
    
    # Enable blog sections by default
    config.wheelhouse.blog.sections = true
    
    isolate_namespace Blog
    
    resources do
      ::Blog::Blog.select(:id, :label).map do |b|
        Resource(::Blog::Post, :sublabel => b.label, :url => blog.new_blog_post_path(b))
      end
    end
    
    resource { Resource(::Blog::Blog) }
    
    sections do
      ::Blog::Blog.select(:id, :label).map do |blog|
        Section(blog.label, blog)
      end if ::Blog::Plugin.config.wheelhouse.blog.sections
    end
    
    initializer "precompile assets" do |app|
      app.config.assets.precompile << "wheelhouse-blog/admin.*"
    end
  end
end
