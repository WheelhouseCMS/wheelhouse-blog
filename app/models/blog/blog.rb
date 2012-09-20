class Blog::Blog < Wheelhouse::Resource
  include Wheelhouse::Resource::Addressable
  include Wheelhouse::Resource::Content

  property :title, String, :translate => true, :required => true
  property :posts_per_page, Integer, :default => 20

  has_many :posts, :class => "Blog::Post", :conditions => { :state => 'Published' }, :order => :published_at.desc
  has_many :all_posts, :class => "Blog::Post", :order => :created_at.desc

  activities :all
  
  icon "wheelhouse-blog/blog.png"
  
  self.default_template = "blog/index"
  
  def handler
    Blog::BlogHandler
  end
  
  def find_post(year, month, permalink)
    posts.find_by_year_and_month_and_permalink!(year.to_i, month.to_i, permalink)
  end
  
  def feed_path
    path('feed.xml')
  end
  
  def tag_path(tag)
    path('tag', tag.parameterize)
  end
  
  def category_path(category)
    path('category', category.parameterize)
  end
  
  def archive_path(year, month=nil)
    month ? path(year.to_i, month.to_i) : path(year.to_i)
  end
  
  def archives(options={})
    Blog::Archive.build(self, options)
  end
  
  def tags
    Blog::Tag.for_blog(self).cached
  end
  
  def categories
    Blog::Category.for_blog(self).cached
  end
  
  def additional_children
    posts
  end
end
