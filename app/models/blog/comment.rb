class Blog::Comment < Wheelhouse::EmbeddedResource
  property :id, MongoModel::Reference, :as => '_id', :default => proc { ::BSON::ObjectId.new.to_s }
  
  property :author, String, :required => true
  property :email, String, :required => true
  property :comment, String, :required => true
  property :posted_at, Time
  
  def email_with_author_name
    "#{author} <#{email}>"
  end
  
  def prepare
    self.posted_at = Time.now
    self
  end
end
