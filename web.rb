Bundler.require()
require "sinatra"
require "sinatra/content_for"
require "sinatra/reloader" if development?

$stdout.sync = true

enable :sessions

# Require Models
DataMapper.setup :default, ENV['DB_PATH']
Dir[Dir.pwd + '/models/*.rb'].each { |file| require file }
DataMapper.auto_upgrade!
DataMapper.finalize

@current_user = nil

  def current_user
    @current_user
  end

  def logged_in?
    # nil id means user doesn't exist
    @current_user.id
  end

  def setup_user cookies, session
    oauth = Koala::Facebook::OAuth.new(
      ENV['FB_APP_ID'],
      ENV['FB_APP_SECRET']
      # "#{request.protocol}#{request.host_with_port}/"
    )

    user = session[:user_id] && User.get(session[:user_id])

    if user
      access_token = user.access_token
      if user.access_token # && user.token_expire > Time.now.to_i
        api = Koala::Facebook::API.new(user.access_token)
        begin
          profile = api.get_object('me')
          if profile['id'] == user.id
            @current_user = user
            @api = api
          end
        rescue Koala::Facebook::APIError => err
          user.access_token = nil
          # user.token_expire = nil
          user.save
          user = nil
          session.clear
        end
      end
    end

    if @api.nil?
      begin
        info = oauth.get_user_info_from_cookies(cookies)
        unless info.nil?
          @api = Koala::Facebook::API.new(info['access_token'])
          fbid = info.nil? ? false : info['user_id']

          @current_user = User.get_or_create_by_fbid(fbid, @api, session)
          @current_user.access_token = info['access_token']
          # @current_user.token_expire = Time.now.to_i + info['expires'].to_i
          @current_user.save
          session[:user_id] = @current_user.id
        end
      rescue Koala::Facebook::APIError => err
        # Lets clear the cookies so we don't hit this again
        cookies.delete("fbsr_#{ENV['FB_APP_ID']}")
      end
    end

    @current_user ||= User.new
  end

# # returns nil if no current user
# def current_user cookies
#   puts "cookies: #{cookies}"
#   u = nil
#   koala = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET'])

#   user_details = nil

#   unless u = User.first(:session_id => cookies['rack.session'])
#     if user_details = koala.get_user_info_from_cookies(cookies)
#       graph = Koala::Facebook::API.new(user_details['access_token'])
#       me = graph.get_object("me")
#       unless u = User.get(me['id'])
#         u = User.create({
#             :id => me['id'],
#             :name => me['name'],
#             :profile_url => me['link'],
#             :gender => me['gender'],
#             :access_token => user_details['access_token'],
#             :session_id => cookies['rack.session']
#           })
#         u.get_likes_from_graph graph
#       end
#     end
#   end

#   u
# end

get '/' do
  erb :index
end

get '/search' do
  setup_user cookies, session
  if logged_in?
    @rooms = Room.all({:name.like => "%" + params[:query] + "%"}).sort_by! { |r| -r.people }
    erb :roomlist, :layout => false
  end
end

post '/create' do
  setup_user cookies, session
  if logged_in?
    # params[:name] = params[:name].delete(' ').downcase!
    if Room.first({:name => params[:name]})
      return [403, 'group already exists']
    else
      @rooms = [ Room.create({:name => params[:name]}) ]
      erb :roomlist, :layout => false
    end
  end
end

get '/room/:roomname' do
  setup_user cookies, session
  if logged_in? && r = Room.first(:name => params[:roomname])
    current_user.room = r
    current_user.save

    @matches = current_user.get_room
    erb :userlist, :layout => false
  end
end

get '/home' do
  setup_user cookies, session
  if logged_in?
    erb :home
  else
    redirect :/
  end
end

get '/:name' do
  setup_user cookies, session
  if logged_in?
    @roomTitle = params[:name]
    @exists = (r = Room.first(:name => params[:name])) ? true : false
    erb :home
  else
    redirect :/
  end
end