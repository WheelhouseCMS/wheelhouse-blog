module Blog::PaginationHelper
  WILL_PAGINATE_BASE = defined?(WillPaginate::ViewHelpers) ? WillPaginate::ViewHelpers::LinkRenderer : WillPaginate::LinkRenderer
  
  class LinkRenderer < WILL_PAGINATE_BASE
    PAGE_PARAMETER = /\/page\/\d+$/
    
    def pagination
      items = @options[:page_links] ? windowed_page_numbers : []
      items.unshift :previous_page unless @options[:previous_link] == false
      items.push :next_page unless @options[:next_link] == false
      items
    end
    
  protected
    def url(page)
      path = current_path
      
      if page == 1
        path = path.sub(PAGE_PARAMETER, "")
      elsif path =~ PAGE_PARAMETER
        path = path.sub(PAGE_PARAMETER, "/page/#{page}")
      else
        path += "/page/#{page}"
      end
      
      Wheelhouse::PathUtils.normalize_path(path)
    end
    alias url_for url

    def current_path
      request = @template.request

      if request.respond_to?(:original_fullpath)
        request.original_fullpath.sub(/\?#{request.query_string}$/, "")
      else
        request.path
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
