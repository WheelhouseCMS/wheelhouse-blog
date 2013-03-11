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
  
  def self.all_posts_for(site)
    blog_ids = ::Blog::Blog.where(:site_id => site.id).select(:id).map(&:id)
    ::Blog::Post.where(:blog_id.in => blog_ids).published
  end
end
