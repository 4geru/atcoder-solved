require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require './lib'
require 'chartkick'

get '/' do
  @contests = problems
  @solved = Hash[solved(copy(get_user)).sort_by { |k, v| v.length }.reverse]
  @users = @solved.keys
  erb :problems
end

get '/graph' do
  @users = get_user
  @graph_info = graph(copy(get_user))
  erb :graph
end

get '/solved/:id' do
  @users = get_user
  @contests = problems
  @solved = solved(get_user)
  
  @users = @users.sort_by{|user| -@solved[user].length }.map{ | user| user }
  case params[:id]
  when "abc" then
    erb :abc
  when "arc" then
    erb :arc
  when "agc" then 
    erb :agc
  when "other" then
    erb :other
  end
end

get '/aor' do
  @graph_info = random_aor(get_twitter_users)
  @graph_info.to_s
end
