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
    'name' => 'Amir Sharif'
  }
  ]
  erb :result
end

get '/logintest' do
  erb :logintest
end