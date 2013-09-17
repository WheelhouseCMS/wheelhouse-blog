module Blog::BlogHelper
  def blog(label=nil)
    @_blogs ||= {}
    
    if label
      @_blogs[label] ||= Blog::Blog.get(label)
    else
      @_blogs[:default] ||= Blog::Blog.first
    end
  end
end
