require "rubygems"
require "bundler"
Bundler.require()

get '/' do
  erb :index
end

get '/result' do
  erb :result
end