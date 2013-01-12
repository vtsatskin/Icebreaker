class Like
  include DataMapper::Resource
 
  belongs_to :user
  property :id,   String, :key => true
end