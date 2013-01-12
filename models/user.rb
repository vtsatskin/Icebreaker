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
  property :hometown_id,       String
  property :hometown_name,       String
  property :current_city_id,   String
  property :current_city_name,   String
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
        :hometown_id => (me['hometown'] ? me['hometown']['id'] : nil),
        :current_city_id => (me['location'] ? me['location']['id'] : nil),
        :hometown_name => (me['hometown'] ? me['hometown']['name'] : nil),
        :current_city_name => (me['location'] ? me['location']['name'] : nil),
        :single =>( me['relationship_status'] ? ( me['relationship_status'] == 'Single') : nil ),
        :birthday => (me['birthday'] ? me['birthday'] : nil),
        :session_id => session[:session_id]
      })

      u.get_likes_from_api api

      u
    end
  end

  def get_likes_from_api api
    likes = api.get_connections("me", "likes")
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
        :mutual_likes => h[:mutual_likes],
        :intro => get_icebreakers(h[:user], h[:mutual_likes])
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

  def profile_picture
    "http://graph.facebook.com/#{id}/picture?height=160&weight=160"
  end

  def get_icebreakers match, mutual_likes
    intro = ["How long did you live in", "What's your favourite spot in", "Do you miss"][Random.rand(3)]
    spot = ["restaurant", "bar", "spot", "thing to do", "park", "mall"][Random.rand(6)]

    sentences = []
    sentences.push("What's your favourite #{spot} in #{self.current_city_name}?") if match.current_city_id == self.current_city_id
    sentences.push("#{intro} #{self.hometown_name}") if match.hometown_id == self.hometown_id  
    sentences.push("We have the same birthday!") if match.birthday == self.birthday
    sentences.push("You both like #{mutual_likes[Random.rand(mutual_likes.count - 1)].name}.") if mutual_likes.count > 1

    groups = mutual_likes.group_by{ |ml| ml.category }
    groups.each do |k,v|
      case(k)
      when "Movie"
        sentences.push("What was your favourite scene in #{v[Random.rand(v.count - 1)]}?") if v.count > 1
      when "Sport"
        sentences.push("Who's you're favorite member of #{v[Random.rand(v.count - 1)]}?") if v.count > 1
      when "Musician/band"
        sentences.push("What's your favorite song by #{v[Random.rand(v.count - 1)]}?") if v.count > 1
      when "Musical genre"
        sentences.push("What do you think is the most interesting about #{v[Random.rand(v.count - 1)]}?") if v.count > 1
      when "Tv show"
        sentences.push("What's was your favorite episode of #{v[Random.rand(v.count - 1)]}?") if v.count > 1
      end
    end
    
    sentences[sentences.count > 1 ? Random.rand(sentences.count - 1) : 0]
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

        mutual_likes = self.likes & match.likes
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

        
        { :score => score, :sentence => sentence, :user => match, :mutual_likes => mutual_likes }
      end
    else
      []
    end
  end

  def profile_picture(height = '160', width = '160')
    "http://graph.facebook.com/#{id}/picture?height=#{height}&width=#{width}"
  end
end
