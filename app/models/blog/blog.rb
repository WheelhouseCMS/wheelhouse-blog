class Blog::Blog < Wheelhouse::Resource
  include Wheelhouse::Resource::Addressable
  include Wheelhouse::Resource::Content

  property :title, String, :translate => true, :required => true

  has_many :posts, :class => "Blog::Post", :conditions => { :state => 'Published' }
  has_many :all_posts, :class => "Blog::Post", :order => :created_at.desc

  activities :all
  
  icon "blog/blog.png"
  
  self.default_template = "blog/index"
  
  def handler
    Blog::BlogHandler
  end
  
  def new_post_admin_path
    new_blog_post_path(self)
  end
  
  def find_post(year, month, permalink)
    posts.find_by_year_and_month_and_permalink!(year.to_i, month.to_i, permalink)
  end
  
  def tag_path(tag)
    path('tag', tag.parameterize)
  end
  
  def category_path(category)
    path('category', category.parameterize)
  end
  
  def archive_path(year, month)
    path(year.to_i, month.to_i)
  end
  
  def archives
    selector = MongoModel::MongoOptions.new(posts.klass, posts.finder_options).to_a.first
    posts.collection.group(:key => [:year, :month], :cond => selector, :initial => { :count => 0 }, :reduce => "function(doc, out) { out.count++ }").map { |hash|
      year, month, count = hash["year"], hash["month"], hash["count"]
      
      [Date.civil(year, month, 1), archive_path(year, month), count.to_i]
    }.sort { |a, b| b.first <=> a.first }
  end
  
  def tags
    selector = MongoModel::MongoOptions.new(posts.klass, posts.finder_options).to_a.first
    posts.collection.distinct(:tags, selector)
  end
  
  def categories
    selector = MongoModel::MongoOptions.new(posts.klass, posts.finder_options).to_a.first
    posts.collection.distinct(:categories, selector)
  end
end
