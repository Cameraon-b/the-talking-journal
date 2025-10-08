class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  validates :role, presence: true
  validates :content, presence: true
end
