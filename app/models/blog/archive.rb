class Blog::Archive
  attr_reader :year, :month
  attr_accessor :count
  
  def initialize(blog, year, month=nil)
    @blog, @year = blog, year.to_i
    @month = month.to_i if month
    yield self if block_given?
  end
  
  def to_s
    format.to_s
  end
  
  def format(format="%B %Y")
    month ? to_date.strftime(format) : year
  end
  
  def path
    @blog.path(year, month)
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
  
  def to_date
    Date.new(year, month, 1)
  end
  
  def <=>(other)
    other.to_date <=> to_date
  end
  
  def self.from_mongo(blog, hash)
    new(blog, hash["year"], hash["month"]) do |archive|
      archive.count = hash["count"].to_i
    end
  end
  
  def self.build(blog, options)
    options[:group] ||= [:year, :month]
    
    scope = blog.posts.current_scope
    selector, _ = MongoModel::MongoOptions.new(scope.klass, scope.finder_options).to_a
    
    scope.collection.group(:key => options[:group],
                           :cond => selector,
                           :initial => { :count => 0 },
                           :reduce => "function(doc, out) { out.count++; }").map { |hash|
      Blog::Archive.from_mongo(blog, hash)
    }.sort
  end
  
  # Backwards-compatiblity with old-style archives
  def to_ary
    [to_date, path, count]
  end

private
  def valid_month?
    month > 0 && month < 12
  end
end
