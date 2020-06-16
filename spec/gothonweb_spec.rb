ENV['APP_ENV'] = 'test'

require './bin/app.rb'  # <-- your sinatra app
require 'rspec'
require 'rack/test'

RSpec.describe 'GothonWeb app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('Hello there, Person!')
  end

  it "prints out the form" do
    get '/hello/'
    expect(last_response).to be_ok
    expect(last_response.body).to include('A Greeting')
  end

  it "accepts user input from the form" do
    post '/hello/', params={:name => 'Olivia', :greeting => "Hi"}
    expect(last_response).to be_ok
    expect(last_response.body).to include('Hello there, Olivia!')
  end
end