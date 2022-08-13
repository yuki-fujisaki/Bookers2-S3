class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :content,length: { in: 1..140 } 
end
