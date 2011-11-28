require "wheelhouse"

module Blog
  class Plugin < Wheelhouse::Plugin
    config.wheelhouse.blog = ActiveSupport::OrderedOptions.new
    
    # Enable blog sections by default
    config.wheelhouse.blog.sections = true
    
    isolate_namespace Blog
    
    resources do
      ::Blog::Blog.select(:id, :label).map do |blog|
        Resource(::Blog::Post, :sublabel => blog.label, :url => blog.new_post_admin_path)
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
