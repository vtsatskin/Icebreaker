class User
  include DataMapper::Resource
 
  property :id,             String, :key => true
  property :gender,         String
  property :single,         Boolean
  property :relationship,   String
  property :first_name,     String
  property :last_name,      String
  property :email,          String
  property :hometown,       String
  property :current_city,   String
  property :birthday,       String
  property :access_token,   String
  property :access_token_timestamp, DateTime
  property :created_at,             DateTime
  property :updated_at,             DateTime
  has 1, :room, :through => Resource
  has n, :users, self, :through => :room
  has n, :likes
  has n, :educations
  has n, :games
  has n, :events
  has n, :beliefs
  has n, :interests
  has n, :workhistorys
end