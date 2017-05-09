require 'bundler/setup'
Bundler.require
require 'dotenv'
Dotenv.load
require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require 'chartkick'
require 'twitter'
require './lib.rb'
require './models/aorlog.rb'

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
  get_user.map{|user| print(user.to_s + ' ' + @solved[user].length.to_s + "\n") }
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
  aor = Aorlog.new({cnt:1}) if aor == nil # ない場合には新しく作る
  aor.cnt *= -1
  # update_at = Time.parse('2017-05-05 00:00:00 +09:00')
  update_at = aor[:updated_at]
  time = Time.now

  if (time - update_at)/60/60 > 2
    # DBの保存
    aor.save({cnt:aor.cnt})

    # 煽る
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["AOR_CONSUMER_KEY"]
      config.consumer_secret     = ENV["AOR_CONSUMER_SECRET"]
      config.access_token        = ENV["AOR_ACCESS_TOKEN"]
      config.access_token_secret = ENV["AOR_ACCESS_TOKEN_RECRET"]
    end

    @graph_info = random_aor(get_twitter_users)
    @graph_info.to_s

    client.update(@graph_info)
    @graph_info
  else
    p time - update_at
    # 煽らない
    "そんなに人を煽るの楽しい？\n#{2 - ((time - update_at)/(60*60)).to_i}時間後にもう一回するのだ〜！"
  end
end