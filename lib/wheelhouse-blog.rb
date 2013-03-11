require "wheelhouse"
require "will_paginate"

module Blog
  class Plugin < Wheelhouse::Plugin
    config.wheelhouse.blog = ActiveSupport::OrderedOptions.new
    
    # Enable blog sections by default
    config.wheelhouse.blog.sections = true
    
    config.precompile << "wheelhouse-blog/admin.*"
    
    isolate_namespace Blog
    
    resources do
      ::Blog::Blog.sections_for_site(site).map do |b|
        Resource(::Blog::Post, :sublabel => b.label, :url => blog.new_blog_post_path(b))
      end
    end
    
    resource { Resource(::Blog::Blog) }
    
    sections do
      ::Blog::Blog.sections_for_site(site).map do |blog|
        Section(blog.label, blog)
      end if ::Blog::Plugin.config.wheelhouse.blog.sections
    end
  end
end
