require 'sinatra'
require './lib/gothonweb/map.rb'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"
enable :sessions
set :session_secret, 'BADSECRET'

get '/' do
  session[:room] = 'START'
  redirect to('/game')
end

get '/game' do
  room = Map::load_room(session)

  if room
    erb :show_room, :locals => {:room => room}
  else
    erb :you_died
  end
end

post '/game' do
  room = Map::load_room(session)
  action = params[:action]

  if room
    next_room = room.go(action) || room.go("*")

    if next_room
      Map::save_room(session, next_room)
    end

    redirect to('/game')
  else
    erb :you_died
  end
end

##The following are exercises in forms and image uploading

get '/email' do
  erb :email_form
end

post '/email' do
  greeting = params[:greeting]
  sender = params[:sender]
  recipient = params[:recipient]
  erb :thank_you, :locals => {'message' => greeting, 'user' => sender, 'recipient' => recipient}
end

get '/upload' do
  erb :image_upload
end

post '/upload' do
  uploaded_file = params[:my_file]
  #log what the file looks like
  puts "The file object is #{uploaded_file}"

  #create a new file in static/filename
  target = open('./static/images/' + uploaded_file[:filename], "w")

  #write the file to our empty file
  target.write(uploaded_file[:tempfile].read)
  target.close()

  pictures = load_pictures
  erb :image_upload, :locals => {'pictures' => pictures}
end

def load_pictures
  return Dir.glob("static/images/*.{jpg,jpeg,png}")
end