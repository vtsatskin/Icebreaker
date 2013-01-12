class User
  include DataMapper::Resource
 
  property :id,             String, :key => true
  property :session_id,     String, :length => 500
  property :profile_url,    String
  property :gender,         String
  property :single,         Boolean
  property :relationship,   String
  property :name,           String
  property :email,          String
  property :hometown,       String
  property :current_city,   String
  property :birthday,       String
  property :picture_link,   String
  property :access_token,   String, :length => 255
  property :access_token_timestamp, DateTime
  property :created_at,             DateTime
  property :updated_at,             DateTime
  has 1, :room, :through => Resource
  has n, :likes, :through => Resource
  has n, :educations
  has n, :games
  has n, :events
  has n, :beliefs
  has n, :interests
  has n, :workhistorys

  def self.get_or_create_by_fbid(fbid, api, session)
    if u = User.get(fbid)
      return u
    else
      me = api.get_object("me")
      u = User.create({
        :id => me['id'],
        :name => me['name'],
        :profile_url => me['link'],
        :gender => me['gender'],
        :session_id => session[:session_id]
      })

      u.get_likes_from_api api

      u
    end
  end

  def get_likes_from_api api
    likes = api.get_connections("me", "likes")
    puts "likes: #{likes}"
    if likes && !likes.empty?
      likes.each { |l| self.likes << Like.first_or_create(:id => l['id'], :name => l['name'], :category => l['category']) }
    end
    self.save
  end

  def get_room
    self.get_mutual_likes_in_room.map do |h|
      {
        :picture => h[:user].profile_picture,
        :url => h[:user].profile_url,
        :name => h[:user].name,
        :intro => 'tbd'
      }
    end
  end

  def get_mutual_likes_in_room
    if room = self.room
      (room.users - self).map do |user|
        score = 0
        mutual_likes = self.likes & user.likes
        score += 5 * mutual_likes.count

        { :score => score, :user => user, :mutual_likes => mutual_likes }
      end
    else
      []
    end
  end

  def get_results
    if room = self.room
      (room.users - self).map do |match|
        score = 0
        if self.gender != match.gender and self.single == true and match.single == true
          score += 20
        end
        if self.hometown == match.hometown and self.hometown != nil
          score += 15
        end
        if self.current_city == match.current_city and self.current_city != nil
          score += 5
        end
        if self.birthday == match.birthday and self.birthday != nil
          score += 5
        end

        puts "self.likes: #{self.likes}"
        puts "match.likes: #{match.likes}"

        mutual_likes = self.likes & match.likes
        puts "mutual_likes: #{mutual_likes}"
        score += 5 * mutual_likes.count

        self.educations.each do |education|
          if match.educations.include?(education)
            score += 10
          end
        end
        self.games.each do |game|
          if match.games.include?(game)
            score += 2
          end
        end
        self.events.each do |event|
          if match.events.include?(event)
            score += 3
          end
        end
        self.beliefs.each do |belief|
          if match.beliefs.include?(belief)
            score += 10
          end
        end
        self.interests.each do |interest|
          if match.interests.include?(interest)
            score += 7
          end
        end
        self.workhistorys.each do |workhistory|
          if match.workhistorys.incude?(workhistory)
            score += 10
          end
        end
        #GENERATE SENTENCE HERE
        case Random.rand(3)
        when 1
          if match.current_city.id == self.current_city.id
            sentence = "You both live in #{self.current_city.name}"
          elsif match.hometown.id == self.hometown.id
            sentence = "You both live in #{self.hometown.name}"
          else
            if mutual_likes.count > 0
              sentence = "You both like #{mutual_likes[Random.rand(mutual_likes.count - 1)].name}."
            else
              sentence = "You don't seem to have much in common"
            end
          end
        when 2
          if match.birthday == self.birthday
            sentence = "You have the same birthday!"
          else
            if mutual_likes.count > 0
              sentence = "You both like #{mutual_likes[Random.rand(mutual_likes.count - 1)].name}."
            else
              sentence = "You don't seem to have much in common"
            end
          end
        when 3
          if mutual_likes.count > 0
            sentence = "You both like #{mutual_likes[Random.rand(mutual_likes.count - 1)].name}."
          end
          else
            sentence = "You don't seem to have much in common"
          end
        end
        { :score => score, :sentence => sentence, :user => match, :mutual_likes => mutual_likes }
      end
    else
      []
  end

  def profile_picture
    "http://graph.facebook.com/#{id}/picture?height=160&weight=160"
  end
end
