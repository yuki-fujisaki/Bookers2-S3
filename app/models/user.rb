class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォロー・フォロワー機能修正箇所
  # アソシエーションに中間テーブルを介していない
  # - has_many :followers, source: :follower
  has_many :followers, through: :reverse_of_relationships, source: :follower
  
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォロー・フォロワー機能修正箇所
  # アソシエーションに中間テーブルを介していないgi
  # - has_many :followings, source: :followed
  has_many :followings, through: :relationships, source: :followed

  # →rails db:migrateが通るようになった
  
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    # フォロー・フォロワー機能修正箇所
    # find_byがfindになっているのでデータ探索できない
    # - relationships.find(followed_id: user.id).destroy
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def self.search(search,word)
    if search == "forward_match"
      users = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      users = User.where("name LIKE?","%#{word}")
    elsif search == "perfect_match"
      users = User.where(name: "#{word}")
    elsif search == "partial_match"
      users = User.where("name LIKE?","%#{word}%")
    else
      users = User.all
    end
    return users
  end

  def get_profile_image(weight, height)
    unless self.profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    self.profile_image.variant(resize_to_fill: [weight,height]).processed
  end
end
