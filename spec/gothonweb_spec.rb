ENV['APP_ENV'] = 'test'

require './bin/app.rb'  # <-- your sinatra app
require 'rspec'
require 'rack/test'
require 'spec_helper'

RSpec.describe 'GothonWeb app' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "the homepage redirects you to the sign up page" do
    get '/'
    follow_redirect!

    expect(last_response).to be_ok
    expect(last_response.body).to include('Welcome to an Awesome Web Game! You choose your adventure: Gothons From Planet Percal #25 or Dungeon Maze')
  end

end