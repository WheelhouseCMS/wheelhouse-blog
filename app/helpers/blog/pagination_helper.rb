module Blog::PaginationHelper
  class LinkRenderer < WillPaginate::LinkRenderer
    PAGE_PARAMETER = /\/page\/\d+$/
    
  protected
    def url_for(page)
      path = @template.request.path
      
      if page == 1
        path.sub(PAGE_PARAMETER, "")
      elsif path =~ PAGE_PARAMETER
        path.sub(PAGE_PARAMETER, "/page/#{page}")
      else
        path + "/page/#{page}"
      end
    end
  end
  
  DEFAULTS = {
    :renderer => LinkRenderer,
    :next_label => "Older Posts &raquo;",
    :previous_label => "&laquo; Newer Posts",
    :page_links => false
  }
  
  def blog_pagination(options={})
    will_paginate(@posts, DEFAULTS.merge(options)) if @posts
  end
end
