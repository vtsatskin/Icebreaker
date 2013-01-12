Bundler.require()

configure :development do
  DataMapper.setup :development, 'sqlite://db/icebreak_development'
end

get '/' do
  erb :index
end

get '/result' do
  erb :result
end

get '/logintest' do
  erb :logintest
end