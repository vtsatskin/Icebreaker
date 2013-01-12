Bundler.require()
require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader" if development?

configure :development do
  DataMapper.setup :development, 'sqlite://db/icebreak_development'
end

get '/' do
  erb :index
end

post '/search' do
  []
end

get '/result' do
  @test = "fuck shit up"
  @matches = [ {
    'name' => 'Amir Sharif',
    'likes' => ['cereal', 'programming', 'laptops']
  }
  ]
  erb :result
end

get '/authenticated' do
  @koala = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET'])
  user_details = @koala.get_user_info_from_cookies(cookies)
  if user_details
    @graph = Koala::Facebook::API.new(user_details['access_token'])
    @graph.get_object("me")
  else
    "something fucked up"
  end

  erb :authenticated
end

get '/logintest' do
  erb :logintest
end