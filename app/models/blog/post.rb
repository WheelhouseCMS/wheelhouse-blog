class Blog::Post < Wheelhouse::Resource
  include Wheelhouse::Resource::Renderable
  include Wheelhouse::Resource::Versioned
  include Wheelhouse::Resource::Content
  
  belongs_to :blog, :class => "Blog::Blog"

  property :title, String, :translate => true, :required => true
  property :permalink, String, :required => true
  property :state, String, :default => 'Published'
  property :published_at, Time
  property :year, Integer
  property :month, Integer
  
  property :tags, Wheelhouse::Tags
  property :categories, Wheelhouse::Tags
  
  property :comments, CommentCollection

  index :_tags
  before_save { attributes[:_tags] = tags.map(&:parameterize) }
  
  index :_categories
  before_save { attributes[:_categories] = categories.map(&:parameterize) }
  
  activities :all, :resource_name => :title
  
  icon "wheelhouse-blog/post.png"
  
  validates_uniqueness_of :permalink, :scope => :blog_id
  
  scope :published, where(:state => 'Published').order(:published_at.desc)
  scope :tagged_with, lambda { |tag| where(:_tags => tag.parameterize) }
  scope :in_category, lambda { |category| where(:_categories => category.parameterize) }
  
  before_save :set_published_timestamp, :if => :published?
  before_save :cache_author_name
  before_save :set_admin_sort_index
  
  delegate :site, :to => :blog
  
  after_save :clear_cache!
  after_destroy :clear_cache!
  public :clear_cache!
  
  after_save :update_taxonomies
  after_destroy :update_taxonomies
  
  self.parent_resource = :blog
  self.default_template = "post"
  
  def published?
    state == 'Published'
  end
  
  def path(*args)
    blog.path(published_at.year, published_at.month, permalink, *args)
  end
  
  def comments_path
    "#{path}#comments"
  end
  
  def comments
    all_comments
  end
  
  def all_comments
    read_attribute(:comments)
  end
  
  def author_name
    read_attribute(:author_name) || (author && author.name)
  end
  
  def author
    created_by
  end
  
  def published_at
    read_attribute(:published_at) || Time.now
  end

  def admin_path
    persisted? ? blog_post_path(blog_id, self) : blog_posts_path(blog_id)
  end
  
  def handler
    Blog::PostHandler
  end

private
  def set_published_timestamp
    self.published_at = published_at
    self.year         = published_at.year
    self.month        = published_at.month
  end
  
  def cache_author_name
    write_attribute(:author_name, author.name) if author
  end
  
  def update_taxonomies
    Blog::Tag.refresh
    Blog::Category.refresh
  end
  
  def set_admin_sort_index
    attributes[:_admin_sort_index] = published? ? [0, published_at.to_i] : [1, updated_at.to_i]
  end
end
