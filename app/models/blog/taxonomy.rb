class Blog::Taxonomy
  include MongoModel::MapReduce
  
  class_attribute :taxonomy_type
  
  class << self
    alias_method :subclass_new, :new
  end
  
  def self.new(type)
    Class.new(self) do
      self.taxonomy_type = type
      
      def self.new(*args, &block)
        subclass_new(*args, &block)
      end
    end
  end
  
  self.parent_collection = Blog::Post.collection
  
  attr_reader :name, :count
  attr_accessor :blog
  
  def initialize(name, count)
    @name, @count = name, count.to_i
  end
  
  def path
    raise "#path requires a blog to be set" unless blog
    blog.send(path_method, name)
  end
  
  def to_s
    name
  end
  
  def parameterize
    name.parameterize
  end
  
  def hash
    name.hash
  end
  
  def inspect
    "#<#{self.class.name} \"#{name}\">"
  end
  
  def ==(other)
    if other === self.class
      self == other
    else
      name == other
    end
  end
  alias eql? ==
  
  def self.alphabetical
    order(:"_id.name".asc)
  end
  
  def self.top(n=nil)
    ordered = order(:value.desc)
    n ? ordered.first(n) : ordered
  end
  
  def self.refresh
    scoped.to_a
  end
  
  def self.for_blog(blog)
    where('_id.blog_id' => blog.id).on_load do |taxonomy|
      taxonomy.blog = blog
    end
  end
  
  def self.from_mongo(attrs)
    new(attrs['_id']['name'], attrs['value'])
  end
  
  def self.map_function
    <<-MAP
    function() {
      if (!this.#{taxonomy_type}) { return; }
      
      for (i in this.#{taxonomy_type}) {
        emit({ blog_id: this.blog_id, name: this.#{taxonomy_type}[i] }, 1);
      }
    }
    MAP
  end
  
  def self.reduce_function
    <<-REDUCE
    function(key, values) {
      var count = 0;
      
      for (i in values) {
        count += values[i];
      }
      
      return count;
    }
    REDUCE
  end

private
  def path_method
    "#{self.class.taxonomy_type.to_s.singularize}_path"
  end
end
