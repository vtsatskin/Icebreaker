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
  property :picture_link,   String
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

  def get_results
    results = Array.new
    each self.users do |match|
      Int score = 0
      if self.gender != match.gender and self.single == true and match.single == true
        score += 20
      end
      if self.hometown == match.hometown
        score += 15
      end
      if self.current_city == match.current_city
        score += 5
      end
      if self.birthday == match.birthday
        score += 5
      end
      each self.likes do |like|
        if match.likes.include?(like)
          score += 5
        end
      end
      each self.educations do |education|
        if match.educations.include?(education)
          score += 10
        end
      end
      each self.games do |game|
        if match.games.include?(game)
          score += 2
        end
      end
      each self.events do |event|
        if match.events.include?(event)
          score += 3
        end
      end
      each self.beliefs do |belief|
        if match.beliefs.include?(belief)
          score += 10
        end
      end
      each self.interests do |interest|
        if match.interests.include?(interest)
          score += 7
        end
      end
      each self.workhistorys do |workhistory|
        if match.workhistorys.incude?(workhistory)
          score += 10
        end
      end
      hash = { :score => score, :user => match }
      array.push
    end
    results.sort_by { |usr| usr[:score] }
    return results
  end
end
