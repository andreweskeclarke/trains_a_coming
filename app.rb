require 'sinatra'
require "sinatra/json"
require 'sinatra/reloader'
require "json"

get '/' do
  json({:hello => 'world'})
end
