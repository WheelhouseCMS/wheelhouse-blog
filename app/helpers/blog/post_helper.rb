module Blog::PostHelper
  def current_post?(post)
    request.path == post.path
  end
  
  def blog_post_tag_links(post, separator=", ")
    safe_join(post.tags.map { |tag|
      link_to(tag, post.blog.tag_path(tag), :title => "View all posts tagged #{tag}")
    }, separator)
  end
  
  def blog_post_category_links(post, separator=", ")
    safe_join(post.categories.map { |category|
      link_to(category, post.blog.category_path(category), :title => "View all posts in category #{category}")
    }, separator)
  end
end
