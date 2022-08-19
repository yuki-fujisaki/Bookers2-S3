class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments
  has_many :favorites

  validates :star, numericality: {
    less_than_or_equal_to: 5,
    greater_than_or_equal_to: 1
  }, presence: true
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  validates :tag ,presence: true

  scope :day, -> {order(created_at: :desc)}
  scope :star, ->{order(star: :desc)}
  
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.search(search, word)
    if search == "forward_match"
      books = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      books = Book.where("title LIKE?","%#{word}")
    elsif search == "perfect_match"
      books = Book.where(title: "#{word}")
    elsif search == "partial_match"
      books = Book.where("title LIKE?","%#{word}%")
    else
      books = Book.all
    end
    return books
	end
end
