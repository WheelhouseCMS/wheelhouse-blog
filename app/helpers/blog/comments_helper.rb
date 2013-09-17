module Blog::CommentsHelper
  def comment_form(post=@post, options={})
    form_tag(post.comments_path, { :authenticity_token => false }.merge(options)) do
      yield CommentFormHelper.new(@comment, self)
    end
  end
  
  def comment_submitted?
    @comment && @comment.valid?
  end
  
  class CommentFormHelper < Wheelhouse::HelperObject
    def initialize(comment, template)
      @comment = comment || Blog::Comment.new
      super(template)
    end
    
    def label(field, content_or_options=nil, options=nil)
      if content_or_options.is_a?(Hash)
        options = content_or_options
        content_or_options = nil
      end
      
      @template.label(:comment, field, content_or_options, options)
    end
    
    def text_field(field, options={})
      @template.text_field(:comment, field, options.merge(:value => @comment.send(field)))
    end
    
    def text_area(field, options={})
      @template.text_area(:comment, field, options.merge(:value => @comment.send(field)))
    end
    
    def error_message(field)
      content_tag(:p, @comment.errors[field].first, :class => "error") if @comment.errors[field].any?
    end
    
    def submit(label="Submit")
      submit_tag(label)
    end
  end
end
