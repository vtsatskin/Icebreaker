Bundler.require()
require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader" if development?

$stdout.sync = true

# Require Models
DataMapper.setup :default, ENV['DB_PATH']
Dir[Dir.pwd + '/models/*.rb'].each { |file| require file }
DataMapper.auto_upgrade!
DataMapper.finalize

get '/' do
  erb :index
end

get '/search' do
  params[:query]
  @rooms = [
    {
      :id => '1',
      :name => 'Hackathon',
      :people => '32'
    },
    {
      :id => '2',
      :name => 'uWaterloo',
      :people => '10'
    }
  ]
  erb :roomlist, :layout => false
end

post '/create' do
  @name = params[:name]
  @rooms = [
    {
      :id => '3',
      :name => @name,
      :people => '0'
    }
  ]
  erb :roomlist, :layout => false
end

get '/room' do
  params[:roomname]
  @matches = [
    {
      :picture => 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash3/s160x160/553713_444178572296897_1480691611_a.jpg',
      :url => 'https://www.facebook.com/reza.amiracle',
      :name => 'Amir Sharif',
      :intro => 'hows working at vidyard'
    },
    {
      :picture => 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc6/s160x160/196911_10151251142278101_2049639322_a.jpg',
      :url => 'https://www.facebook.com/nick.mostowich',
      :name => 'Nick Mostowich',
      :intro => 'how does it feel to do weed'
    },
    {
      :picture => 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/s160x160/45365_10152319247320484_1066354769_a.jpg',
      :url => 'https://www.facebook.com/vtsatskin',
      :name => 'Valentin Foreskin',
      :intro => 'so how about those long term relationships huh'
    },
    {
      :picture => 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc6/s160x160/223049_10150260199183581_3390501_n.jpg',
      :url => 'https://www.facebook.com/lesia.nalepa',
      :name => 'Lesia Nalepa',
      :intro => 'lets go baby'
    },
    {
      :picture => 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn1/s160x160/543939_10152317556485338_322316796_a.jpg',
      :url => 'https://www.facebook.com/charlottechan19',
      :name => 'Charlotte Chan',
      :intro => 'You know what i think is cool? NFC'
    }
  ]
  erb :userlist, :layout => false
end

get '/:name' do
  @roomTitle = :name
  erb :home
end

get '/authenticated' do
  koala = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET'])
  user_details = koala.get_user_info_from_cookies(cookies)

  puts "gah"
  if user_details
    puts "user details"
    graph = Koala::Facebook::API.new(user_details['access_token'])
    me = graph.get_object("me")

    # Only update user data once
    unless u = User.get(me['id'])
      puts "in"
      u = User.create({
          :id => me['id'],
          :name => me['name'],
          :profile_url => me['link'],
          :gender => me['gender'],
          :access_token => user_details['access_token']
        })
      puts "wtf"
      puts u.save 
      puts u.errors.full_messages
      u.get_likes_from_graph graph
    end
    u
  else
    "something fucked up"
  end

  redirect :home
end

get '/home' do
  erb :home
end

get '/logintest' do
  erb :logintest
end