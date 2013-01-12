class Like
  include DataMapper::Resource
 
  has n, :users, :through => Resource
  property :id,   Integer, :key => true
  property :name, String
  property :category, String
end