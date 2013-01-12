Bundler.require()
require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader" if development?

# Require Models
DataMapper.setup :default, ENV['DB_PATH']
Dir[Dir.pwd + '/models/*.rb'].each { |file| require file }
DataMapper.auto_upgrade!
DataMapper.finalize

get '/' do
  erb :index
end

post '/search' do
  []
end

get '/result' do
  @test = "fuck shit up"
  @matches = [
    {
      :name => 'Amir Sharif',
      :likes => ['cereal', 'programming', 'laptops']
    },
    {
      :name => 'Johnny Smith',
      :likes => ['cereal', 'poo', 'laptops']
    },
    {
      :name => 'Johnny Smith',
      :likes => ['cereal', 'poo', 'laptops']
    },
    {
      :name => 'Johnny Smith',
      :likes => ['cereal', 'poo', 'laptops']
    },
    {
      :name => 'Johnny Smith',
      :likes => ['cereal', 'poo', 'laptops']
    }
  ]
  erb :result
end

get '/authenticated' do
  koala = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET'])
  user_details = koala.get_user_info_from_cookies(cookies)

  if user_details
    graph = Koala::Facebook::API.new(user_details['access_token'])
    me = graph.get_object("me")

    # Only update user data once
    unless u = User.get(me['id'])
      u = User.create({
          :id => me['id'],
          :name => me['name'],
          :profile_url => me['link'],
          :gender => me['gender']
        })
    end
    u
  else
    "something fucked up"
  end

  # erb :authenticated
end

get '/logintest' do
  erb :logintest
end