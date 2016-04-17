class Room < ActiveRecord::Base
  belongs_to :user
  has_many :reviews, dependent: :destroy

  def complete_name
    "#{title}, #{location}"
  end

  def self.search(query)
    if query.present?
      where(["location ILIKE :query OR title ILIKE :query OR description ILIKE :query", query: "%#{query}%"])
    else
      all
    end
  end

  def self.most_recent
    order(created_at: :desc)
  end
end
