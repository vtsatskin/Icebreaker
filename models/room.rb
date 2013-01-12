class Room
  include DataMapper::Resource
 
  property :name,       String
  property :id,         String, :key => true
  property :password,   String
  has n, :users, :through => Resource
end