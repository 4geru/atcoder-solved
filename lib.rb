def copy(users)
  Marshal.load(Marshal.dump(users))
end

def get_user
  @users = [
    'rika0384',
    'shumon_84',
    'ixmel_rd',
    'tuki_remon',
    'noy72',
    'uchi',
    'yuiop',
    'yebityon',
    'vvataarne',
    'pn33550336',
    'honey416x2',
    'Fred373962260',
    'xrimf2145',
    'k16180',
    'kuma13',
    'fuu32',
    'Oike7',
    'nerukichi24',
    'UpGrass',
    'Masumi',
    'p1ne4pple',
    'ampanchi'
  ]
end

def get_twitter_users
  @users = {
    'rika0384' => '@wk1080id',
    'shumon_84' => '@shumon_84',
    'ixmel_rd' => '@mel_fall524',
    'tuki_remon' => '@tukiremon',
    'noy72' => '@noynote',
    'uchi' => '@_4geru',
    'yuiop' => '@IS0283IR',
    'yebityon' => '@sigsigma19',
    'vvataarne' => '@vvataarne',
    'pn33550336'=> nil,
    'honey416x2' => nil,
    'Fred373962260' => nil,
    'xrimf2145' => nil,
    'k16180' => '@newton112358',
    'kuma13' => nil,
    'fuu32' => nil,
    'Oike7' => nil,
    'nerukichi24' => nil,
    'UpGrass' => nil,
    'Masumi' => nil,
    'p1ne4pple' => nil,
    'ampanchi' => nil
  }
end

def graph(users, colors)
  users.map! {|user| 
    uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?user=' + user)
    results = JSON.parse(Net::HTTP.get(uri))
    times = get_graph_times(results)
    problems = get_graph_last(results)
    last_5_problems = problems[0...5].map{|problem|
      now = DateTime.now
      solve = DateTime.parse(problem['ac_time'])
      if (now - solve).to_f < 1 / 24 / 60 # brefore 1h 
        problem[:time] = colors[0] || 'red'
      elsif (now - solve).to_f < 1 # before 1day
        problem[:time] = colors[1] || 'yellow'
      elsif (now - solve).to_f < 7 # before 1week
        problem[:time] = colors[2] || 'blue'
      elsif (now - solve).to_f < 30 # before 1month
        problem[:time] = colors[3] || 'green'
      else
        problem[:time] = colors[4] || 'grey'
      end
      problem
    }
    first_problem = problems[-1]
     # 日付ごとにカウントする
    {name: user, data: times, last_problems: last_5_problems, first_problem: first_problem }
  }.sort_by{|user| -user[:data].last[1]}
end

def get_graph_last(results)
  results.select{ | result | result["status"] == "AC" } # ACだけを選択
  .sort_by{|result| DateTime.parse(result['ac_time']) }.reverse # 日付でソートし
end

def get_graph_times(results)
  before = 0
  results.select{ | result | result["status"] == "AC" } # ACだけを選択
  .map{ |result| result["ac_time"].slice(0..9) } # 時間だけを抽出
  .group_by{| time | time } # 時間でグルーピングする
  .sort.map{ |key, value| 
    before += value.size()
    [key, before] 
  }
end

def problems
  ary = []
  uri = URI.parse('http://kenkoooo.com/atcoder/json/problems.json')
  results = JSON.parse(Net::HTTP.get(uri))
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
  # print users
  users = users.map!{|user| 
    user_str += user + ',' 
    ary[user] = []
  }
  # get problems
  uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?rivals=' + user_str)
  results = JSON.parse(Net::HTTP.get(uri))
  results.map{|problem| 
    begin
      problem["rivals"].map{ |rival|
        ary[rival].push(problem["id"])
      }
    rescue Exception => e
      problem["rivals"] = []
    end
  }
  ary
end

def is_aor(date)
  prev_month = Date.today << 1
  prev_few_days = Date.today - 3
  prev_few_days > date and date > prev_month
end

def aor(users)
  selected_user = users.select{ |username, twitterid| twitterid } # twitter id がある人だけ
  .map{ | username, twitterid |  username } # usernameだけを抽出
  .map{|user| 
    uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?user=' + user)
    results = JSON.parse(Net::HTTP.get(uri))
    last_ac = results.select{ | result | result["status"] == "AC" } # ACだけを選択
    .max {|a, b| a['ac_time'] <=> b['ac_time'] } # 最後に解いた問題をとる
    [user, Date.parse(last_ac['ac_time'])]
  }.select{|user| is_aor(user[1])}
  .map{|user| [user[0], (Date.today - user[1]).to_i]}
end

def aor_end_sentence(day)
  [
    "#{day}日解いてないですよ〜♪",
    "Atcoder#{day}日解いてないですよ〜♪",
    "進捗ないのですか？〜♪",
  ].sample
end

def random_aor(users)
  user = aor(users).sample
  "#{users[user[0]]} " + aor_end_sentence(user[1])
end