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

  def self.in_season_with_details(date)
    in_season(date).select('fish.*, fish_seasons.start_date, fish_seasons.end_date')
  end

  # validates :image, attached: true,
  #           content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/svg+xml']
end
