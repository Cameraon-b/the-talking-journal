class ChatMessage < ApplicationRecord
  belongs_to :user
  validates :role, presence: true
  validates :content, presence: true
end
