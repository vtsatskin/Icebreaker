Bundler.require()
require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader" if development?

configure :development do
  DataMapper.setup :default, 'sqlite://db/icebreak_development.db'
end

get '/' do
  erb :index
end

post '/search' do
  []
end

post '/create' do
  [] #todo: create room code here
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

  puts cookies
  erb :authenticated
end

get '/logintest' do
  erb :logintest
end