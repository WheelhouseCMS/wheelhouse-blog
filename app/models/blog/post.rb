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

  property :_tags, Wheelhouse::Tags, :index => true
  property :_categories, Wheelhouse::Tags, :index => true
  
  activities :all, :resource_name => :title
  
  icon :blog, "images/post.png"
  
  validates_uniqueness_of :permalink, :scope => :blog_id
  
  default_scope order(:published_at.desc)
  
  scope :tagged_with, lambda { |tag| where(:_tags.all => tag) }
  scope :in_category, lambda { |category| where(:_categories.all => category) }
  scope :in_year_and_month, lambda { |year, month| where(:year => year, :month => month) }
  
  scope :properties_for_admin, select(:id, :type, :title, :state, :published_at, :created_by_id, :blog_id)
  
  before_save :set_published_timestamp
  before_save :parameterize_tags_and_categories
  
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

  def admin_path
    if persisted?
      blog_blog_post_path(blog_id, self)
    else
      blog_blog_posts_path(blog_id)
    end
  end
  
  def handler
    Blog::PostHandler
  end

private
  def set_published_timestamp
    if published?
      self.published_at ||= Time.now
      self.year = published_at.year
      self.month = published_at.month
    end
  end
  
  def parameterize_tags_and_categories
    self._tags = tags.map(&:parameterize)
    self._categories = categories.map(&:parameterize)
  end
end
