module Blog::BlogHelper
  def blog(label=nil)
    @_blogs ||= {}
    
    if label
      @_blogs[label] ||= Blog::Blog.get(label)
    else
      @_blogs[:default] ||= Blog::Blog.first
    end
  end
  
  def blog_post_tag_links(post)
    post.tags.map { |tag| link_to(tag, post.blog.tag_path(tag), :title => "View all posts tagged #{tag}") }.join(', ').html_safe
  end

  def format_month(year, month)
    "#{Date::MONTHNAMES[month]} #{year}"
  end
end
