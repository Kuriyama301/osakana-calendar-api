class Fish < ApplicationRecord
  has_many :fish_seasons
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
  validates :features, presence: true
  validates :nutrition, presence: true
  validates :origin, presence: true

  # 画像の存在を確認
  validates :image, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
end
