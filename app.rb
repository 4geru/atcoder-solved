require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require './lib'
require 'chartkick'

get '/' do
  @contests = problems
  @solved = Hash[solved(copy(@users)).sort_by { |k, v| v.length }.reverse]
  @users = @solved.keys
  erb :problems
end

get '/test' do
  @users = get_user
  @contests = problems
  @graph_info = lib_solved(copy(@users))
  erb :test
end

get '/solved/:id' do
  @users = get_user
  @contests = problems
  @solved = solved(@users)
  
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
def copy(users)
  Marshal.load(Marshal.dump(users))
end

def problems
  ary = []
  uri = URI.parse('http://kenkoooo.com/atcoder/json/problems.json')
  json = Net::HTTP.get(uri)
  results = JSON.parse(json)
  for result in results do
    ary.push({
      contest: result['contest'],
      id: result['id'],
      name: result['name']
    })
  end
  ary
end

def solved(users)
  ary = {}
  user_str = ""
  users = users.map{|user| 
    user_str += user + ',' 
    ary[user] = []
  }
  # get problems
  uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?rivals=' + user_str)
  json = Net::HTTP.get(uri)
  results = JSON.parse(json)
  results.map! {|problem| 
    problem["rivals"].map! { |rival|
      ary[rival].push(problem["id"])
    }
  }
  ary
end