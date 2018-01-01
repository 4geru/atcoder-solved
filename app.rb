require 'bundler/setup'
Bundler.require
require 'sinatra/reloader'
require 'json'
require 'net/http'
require 'uri'
require 'date'
require './lib'

get '/' do
  @solved = getResultCount
  @users = get_users
  # @contests = getResults('abc')
  erb :problems
end

get '/solved/:contest_id' do
  @users = get_users
  @contests = getResults(params[:contest_id])
  erb :contest
end

get '/graph' do
  @graph = getGraph
  @users = get_users

  # @contests = getResults('abc')
  erb :graph
end
