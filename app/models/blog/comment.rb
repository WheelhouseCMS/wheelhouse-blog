class Blog::Comment < Wheelhouse::EmbeddedResource
  property :id, MongoModel::Reference, :as => '_id', :default => proc { ::BSON::ObjectId.new.to_s }
  
  property :author, String, :required => true
  property :email, String, :required => true
  property :comment, String, :required => true
  property :approved, Boolean, :default => true, :protected => true
  property :posted_at, Time, :required => true, :protected => true
  
  # Basic email validation - assert that one @ exists in the given email
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  
  def email_with_author_name
    "#{author} <#{email}>"
  end
end
