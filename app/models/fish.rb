class Fish < ApplicationRecord
  has_many :fish_seasons, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :features, presence: true
  validates :nutrition, presence: true
  validates :origin, presence: true

  scope :in_season, ->(date) {
    joins(:fish_seasons).where(
      '(fish_seasons.start_month < fish_seasons.end_month AND ? BETWEEN fish_seasons.start_month AND fish_seasons.end_month) OR ' \
      '(fish_seasons.start_month > fish_seasons.end_month AND (? >= fish_seasons.start_month OR ? <= fish_seasons.end_month)) OR ' \
      '(fish_seasons.start_month = fish_seasons.end_month AND ' \
      '((fish_seasons.start_month = ? AND fish_seasons.start_day <= ? AND fish_seasons.end_day >= ?) OR ' \
      '(fish_seasons.start_month = ? AND ((fish_seasons.start_day <= ? AND fish_seasons.end_day >= ?) OR ' \
      '(fish_seasons.start_day > fish_seasons.end_day AND (? >= fish_seasons.start_day OR ? <= fish_seasons.end_day))))))',
      date.month, date.month, date.month, date.month, date.day, date.day, date.month, date.day, date.day, date.day, date.day
    )
  }

  def self.in_season_with_full_details(date)
    in_season(date)
      .select('fish.*, fish_seasons.start_month, fish_seasons.start_day, fish_seasons.end_month, fish_seasons.end_day')
      .includes(:fish_seasons)
      .with_attached_image
  end

  def image_url
    Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) if image.attached?
  end

  def season_info
    current_season = fish_seasons.find { |season| season.in_season?(Date.today) }
    return nil unless current_season

    {
      start_date: "#{current_season.start_month}月#{current_season.start_day}日",
      end_date: "#{current_season.end_month}月#{current_season.end_day}日"
    }
  end
end
