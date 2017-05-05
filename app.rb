require 'bundler/setup'
Bundler.require
require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require 'chartkick'
require './lib.rb'
require './models/db.rb'



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
  aor = Aorlog.first # 最初のデータを取る
  aor = Aorlog.new({cnt:0}) if aor == nil # ない場合には新しく作る
  aor.cnt *= -1
  update_at = Time.parse('2017-05-05 00:00:00 +09:00')#aor[:updated_at]
  aor.save
  time = Time.now

  [((time - update_at)/60/60).to_s, time.to_s]
  if (time - update_at)/60/60 > 6
    # 煽る
    @graph_info = random_aor(get_twitter_users)
    @graph_info.to_s
  else
    # 煽らない
    'false'
  end
end
