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

  index :_tags
  before_save { attributes[:_tags] = tags.map(&:parameterize) }
  
  index :_categories
  before_save { attributes[:_categories] = categories.map(&:parameterize) }
  
  activities :all, :resource_name => :title
  
  icon "wheelhouse-blog/post.png"
  
  validates_uniqueness_of :permalink, :scope => :blog_id
  
  default_scope order(:published_at.desc)
  
  scope :tagged_with, lambda { |tag| where(:_tags => tag) }
  scope :in_category, lambda { |category| where(:_categories => category) }
  scope :in_year_and_month, lambda { |year, month| where(:year => year, :month => month) }
  
  scope :properties_for_admin, select(:id, :type, :title, :state, :published_at, :created_by_id, :blog_id)
  
  before_save :set_published_timestamp
  
  delegate :site, :to => :blog
  after_save :clear_cache!
  after_destroy :clear_cache!
  
  self.parent_resource = :blog
  self.default_template = "post"
  
  def published?
    state == 'Published'
  end
  
  def path
    if published? && blog
      blog.path(year, month, permalink)
    end
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
    if published?
      self.published_at ||= Time.now
      self.year  = published_at.year
      self.month = published_at.month
    end
  end
end
