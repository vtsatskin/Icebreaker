class Education
  include DataMapper::Resource
 
  belongs_to :user
  property :id,   String, :key => true
end
 
class Game
  include DataMapper::Resource
 
  belongs_to :user
  property :id,   String, :key => true
end
 
class Event
  include DataMapper::Resource
 
  belongs_to :user
  property :id,   String, :key => true
end
 
class Belief
  include DataMapper::Resource
 
  belongs_to :user
  property :id,   String, :key => true
end
 
class Interest
  include DataMapper::Resource
 
  belongs_to :user
  property :id,   String, :key => true
end
 
class Workhistory
  include DataMapper::Resource
 
  belongs_to :user
  property :id,   String, :key => true
end