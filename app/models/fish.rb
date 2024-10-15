class Fish < ApplicationRecord
  has_many :fish_seasons, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :features, presence: true
  validates :nutrition, presence: true
  validates :origin, presence: true

  scope :in_season, ->(date) {
    joins(:fish_seasons).where('fish_seasons.start_date <= ? AND fish_seasons.end_date >= ?', date, date)
  }

  def self.in_season_with_full_details(date)
    in_season(date)
      .select('fish.*, fish_seasons.start_date, fish_seasons.end_date')
      .includes(:fish_seasons)
      .with_attached_image
  end

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
    end
  end

  def season_info
    current_season = fish_seasons.find { |season| season.start_date <= Date.today && season.end_date >= Date.today }
    return nil unless current_season

    {
      start_date: current_season.start_date.strftime("%Y年%m月%d日"),
      end_date: current_season.end_date.strftime("%Y年%m月%d日")
    }
  end
end
