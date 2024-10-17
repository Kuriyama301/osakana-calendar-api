class Fish < ApplicationRecord
  has_many :fish_seasons
  has_one_attached :image

  def self.in_season_on(date)
    joins(:fish_seasons).where(
      "(fish_seasons.start_month <= :month AND fish_seasons.end_month >= :month) OR " \
      "(fish_seasons.start_month > fish_seasons.end_month AND " \
      "(fish_seasons.start_month <= :month OR fish_seasons.end_month >= :month))",
      month: date.month
    ).distinct
  end

  def image_url
    image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(image) : nil
  end
end
