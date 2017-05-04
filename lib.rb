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
  ]
end

def graph(users)
  users.map! {|user| 
    uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?user=' + user)
    results = JSON.parse(Net::HTTP.get(uri))
    before = 0
    times = results.select{ | result | result["status"] == "AC" } # ACだけを選択
    .map{ |result| result["ac_time"].slice(0..9) } # 時間だけを抽出
    .group_by{| time | time } # 時間でグルーピングする
    .sort.map{ |key, value| 
      before += value.size()
      [key, before] 
    } # 日付ごとにカウントする
    {name: user, data: times }
  }.sort_by{|user| -user[:data].last[1]}
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
  users = users.map{|user| 
    user_str += user + ',' 
    ary[user] = []
  }
  # get problems
  uri = URI.parse('http://kenkoooo.com/atcoder-api/problems?rivals=' + user_str)
  results = JSON.parse(Net::HTTP.get(uri))
  results.map{|problem| 
    problem["rivals"].map{ |rival|
      ary[rival].push(problem["id"])
    }
  }
  ary
end