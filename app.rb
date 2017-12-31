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



# hoge 
# getContests('arc')
# puts 
# getContests
# getContests().each{|contest_id, problems|
#   puts "#{contest_id}"
#   problems.each{|problem_id, users|
#     puts "  #{problem_id[-1]}"
#     users.map{|info|
#       puts "    #{info[:user]} #{info[:time].strftime("%Y-%m-%d")}"
#     }
#   }
# }
