Faker::Config.locale = :ja

# ゲストユーザー作成
User.create!(name:  "Guest User",
            email: "guest@example.com",
            password:              "12345678",
            password_confirmation: "12345678",
            confirmed_at: Time.zone.now,
            confirmation_sent_at: Time.zone.now)

1.upto(49) do |i|
  name  = Faker::Name.name
  email = "sample-#{i}@example.com"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              confirmed_at: Time.zone.now,
              confirmation_sent_at: Time.zone.now)
end

users = User.order(:created_at).take(10)

users.each_with_index do |user, i|
  user.avatar = open("#{Rails.root}/db/fixtures/avatar/avatar-#{i + 1}.jpg")
  user.save
end


# 都道府県マスタ、市区町村マスタの生成
# CSVファイルを使用することを明示
require 'csv'

# 使用するデータ（CSVファイルの列）を指定
CSVROW_PREFID = 1
CSVROW_PREFNAME = 2
CSVROW_CITYNAME = 3

# CSVファイルを読み込み、DB（テーブル）へ保存
CSV.foreach('db/csv/prefectures_cities.csv') do |row|
  prefecture_id = row[CSVROW_PREFID]
  prefecture_name = row[CSVROW_PREFNAME]
  city_name = row[CSVROW_CITYNAME]

  Prefecture.find_or_create_by(name: prefecture_name)
  City.find_or_create_by(name: city_name, prefecture_id: prefecture_id)
end

# 使用するデータ（CSVファイルの列）を指定
# CSVROW_PREFNAME = 6
# CSVROW_CITYNAME = 7

# CSVファイルを読み込み、DB（テーブル）へ保存
# CSV.foreach('db/csv/KEN_ALL.CSV', encoding: "Shift_JIS:UTF-8") do |row|
#   prefecture_name = row[CSVROW_PREFNAME]
#   city_name = row[CSVROW_CITYNAME]
#   prefecture = Prefecture.find_or_create_by(name: prefecture_name)
#   City.find_or_create_by(name: city_name, prefecture_id: prefecture.id)
# end

wheathers = %w[快晴 晴れ 薄曇り 曇り 煙霧 砂じんあらし 地ふぶき 霧 霧雨 雨 みぞれ 雪 あられ ひょう 雷]
feelings = %w[暑い 暖かい ちょうどいい 寒い あてはまらない]
expectations = %w[今と変化なさそう 回復しそう 下り坂になりそう]

i = 0
users.each do
  1.upto(8) do |j|
    # Cityマスタからランダムに1件返す
    cities = City.where('id >= ?', rand(City.first.id..City.last.id)).first

    j = ((i * 8) + j) + 1
    image = open("#{Rails.root}/db/fixtures/sola/sola-#{j}.jpg")
    caption = Faker::Lorem.paragraph_by_chars
    weather = wheathers.sample
    feeling = feelings.sample
    expectation = expectations.sample
    prefecture_id = cities.prefecture_id
    city_id = cities.id

    users[i].posts.create!(
      image: image,
      caption: caption,
      weather: weather,
      feeling: feeling,
      expectation: expectation,
      prefecture_id: prefecture_id,
      city_id: city_id
    )
  end
  i += 1
end


# i = 0
# 50.times do
#   i += 1
#   title = Faker::Address.state + 'の天気'
#   body = Faker::Lorem.paragraph_by_chars
#   image = open("#{Rails.root}/db/fixtures/sola/sola-#{i}.jpg")
#   users.each { |user| user.posts.create!(title: title, body: body, image: image) }
# end

# wheathers %w['快晴' '晴れ' '薄曇り' '曇り' '煙霧' '砂じんあらし' '地ふぶき' '霧' '霧雨' '雨' 'みぞれ' '雪' 'あられ' 'ひょう' '雷']
# 天気の種類
# （１）快晴
# （２）晴れ
# （３）薄曇り
# （４）曇り
# （５）煙霧
# （６）砂じんあらし
# （７）地ふぶき
# （８）霧
# （９）霧雨
# （１０）雨
# （１１）みぞれ
# （１２）雪
# （１３）あられ
# （１４）ひょう
# （１５）雷