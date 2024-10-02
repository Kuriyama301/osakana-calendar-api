class Fish < ApplicationRecord
  has_many :fish_seasons
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :features, presence: true
  validates :nutrition, presence: true
  validates :origin, presence: true

  # validates :image, attached: true,
  #           content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/svg+xml']
end
