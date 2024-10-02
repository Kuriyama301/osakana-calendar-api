require 'json'
require 'date'

# SVG生成関数（上記のコードをここに配置）
def generate_fish_svg(name)
  # ランダムな背景色を生成
  background_color = "#%06x" % (rand * 0xffffff)

  # SVGテンプレート
  <<-SVG
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 150">
    <rect width="100%" height="100%" fill="#{background_color}"/>
    <text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-family="Arial, sans-serif" font-size="24" fill="white">
      #{name}
    </text>
  </svg>
  SVG
end

# YAMLファイルからデータを読み込む
seed_data = JSON.parse(File.read(Rails.root.join('db', 'seeds', 'fish_data.json')))

seed_data['fishes'].each do |fish_data|
  fish = Fish.create!(
    name: fish_data['name'],
    features: fish_data['features'],
    nutrition: fish_data['nutrition'],
    origin: fish_data['origin']
  )

  # 魚の名前を表示するSVG画像の生成と添付
  svg_content = generate_fish_svg(fish.name)
  fish.image.attach(
    io: StringIO.new(svg_content),
    filename: "#{fish.name.downcase.gsub(' ', '_')}.svg",
    content_type: 'image/svg+xml'
  )
  fish.save!
  
  # 対応するFishSeasonの作成
  season_data = seed_data['fish_seasons'].find { |season| season['fish'] == fish.name }
  if season_data
    FishSeason.create!(
      fish: fish,
      start_date: Date.parse(season_data['start_date']),
      end_date: Date.parse(season_data['end_date'])
    )
  end
end
