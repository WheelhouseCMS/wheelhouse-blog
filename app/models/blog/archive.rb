class Blog::Archive
  attr_reader :year, :month
  
  def initialize(blog, year, month=nil)
    @blog, @year = blog, year.to_i
    @month = month.to_i if month
  end
  
  def format(format="%B %Y")
    month ? to_date.strftime(format) : year
  end
  
  def posts
    @posts ||= begin
      posts = @blog.posts.where(:year => year)
      posts = posts.where(:month => month) if month
      posts
    end
  end
  
  def invalid?
    month.present? && !valid_month?
  end

private
  def to_date
    Date.new(year, month, 1)
  end
  
  def valid_month?
    month > 0 && month < 12
  end
end
