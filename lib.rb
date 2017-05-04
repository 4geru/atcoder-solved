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

def lib_solved(users)
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