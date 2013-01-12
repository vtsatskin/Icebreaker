class Room
  include DataMapper::Resource
 
  property :id,         Serial
  property :name,       String, :required => true
  property :password,   String
  has n, :users, :through => Resource

  def people
    self.users.count
  end
end