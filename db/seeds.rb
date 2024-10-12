require 'json'

def load_json_file(file_path)
  JSON.parse(File.read(file_path))
rescue JSON::ParserError => e
  puts "Error parsing JSON file #{file_path}: #{e.message}"
  {}
rescue Errno::ENOENT
  puts "File not found: #{file_path}"
  {}
end

def process_fish_data(data)
  data['fish'].each do |fish_data|
    fish = Fish.find_or_create_by!(name: fish_data['name']) do |f|
      f.features = fish_data['features']
      f.nutrition = fish_data['nutrition']
      f.origin = fish_data['origin']
    end

    fish_data['fish_seasons'].each do |season_data|
      FishSeason.find_or_create_by!(
        fish: fish,
        start_date: Date.parse(season_data['start_date']),
        end_date: Date.parse(season_data['end_date'])
      )
    end

    attach_image(fish, fish_data, data['active_storage_blobs'])
  end
end

def attach_image(fish, fish_data, blobs)
  if fish_data['active_storage_attachments'].any?
    attachment_info = fish_data['active_storage_attachments'].first
    blob_info = blobs.find { |blob| blob['id'] == attachment_info['blob_id'] }

    image_path = Rails.root.join('db', 'seeds', 'images', blob_info['filename'])

    if File.exist?(image_path)
      unless fish.image.attached?
        file_size = File.size(image_path)
        blob_info['byte_size'] = file_size

        fish.image.attach(
          io: File.open(image_path),
          filename: blob_info['filename'],
          content_type: blob_info['content_type']
        )
        puts "Attached image for #{fish.name}: #{blob_info['filename']} (#{file_size} bytes)"
      end
    else
      puts "Warning: Image file not found for #{fish.name}: #{image_path}"
    end
  end
end

ActiveRecord::Base.transaction do
  # JSONファイルを番号順に処理
  json_files = Dir[Rails.root.join('db', 'seeds', 'json', 'fish_data*.json')].sort_by do |filename|
    filename.scan(/\d+/).first.to_i
  end

  json_files.each do |file_path|
    puts "Processing #{file_path}"
    data = load_json_file(file_path)
    process_fish_data(data) if data.any?
  end
end

puts "Seed data has been successfully loaded!"
