class Post < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :content, length: { in: 3..80 }
end
