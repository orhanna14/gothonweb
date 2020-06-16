require 'sinatra'

set :port, 8080
set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
  person = params['name'] || "Person"
  erb :index, :locals => {'user' => person}
end

get '/hello/' do
  erb :hello_form
end

post '/hello/' do
  greeting = params[:greeting]
  name = params[:name]
  erb :index, :locals => {'greeting' => greeting, 'user' => name}
end

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