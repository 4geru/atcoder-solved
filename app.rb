# require 'bundler/setup'
# Bundler.require
# require 'sinatra/reloader'
require 'json'
require 'net/http'
require 'uri'
require 'date'
# get '/' do
  
# end


def get_users
  [
    'rika0384',
    'shumon_84',
    'ixmel_rd',
    'tuki_remon',
    'noy72',
    'uchi',
    'yuiop',
    'yebityon',
    'vvataarne',
    'kuma13',
    'fuu32',
    'Oike7',
    'Masumi',
    'takaya',
  ]
end

def get_file # 本番では消す
  begin
    str = ''
    File.open('save.json') do |file|
      str = file.read
    end
    return str
  rescue SystemCallError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
  rescue IOError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
  end
end

def hoge
  # root = 'http://beta.kenkoooo.com/atcoder/atcoder-api/results?user=&rivals='
  # puts root + get_users.join(',')

  # uri = URI.parse(root + get_users.join(','))
  # puts Net::HTTP.get(uri)
  # results = JSON.parse(Net::HTTP.get(uri))
  results = JSON.parse(get_file())
  contests = {}
  results.map{|problem| 
    next if problem['result'] != 'AC'
    begin
      contests[problem['contest_id']] = {} if contests[problem['contest_id']].nil?
      contests[problem['contest_id']][problem['problem_id']] = [] if contests[problem['contest_id']][problem['problem_id']].nil?
      # todo 日付sortが必要
      next if contests[problem['contest_id']][problem['problem_id']].find{|info| info[:user] == problem['user_id']}
      
      contests[problem['contest_id']][problem['problem_id']] << {user: problem['user_id'], time: Time.at(problem['epoch_second']) }
    rescue Exception => e
      problem["rivals"] = []
    end
  }
  return contests
end

# hoge 
hoge.each{|contest_id, problems|
  puts "#{contest_id}"
  problems.each{|problem_id, users|
    puts "  #{problem_id[-1]}"
    users.map{|info|
      puts "    #{info[:user]} #{info[:time].strftime("%Y-%m-%d")}"
    }
  }
}
