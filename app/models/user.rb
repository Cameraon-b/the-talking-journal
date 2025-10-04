class User < ApplicationRecord
  # Devise modules already included here (don’t remove those!)
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :entries, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :chat_messages, dependent: :destroy

end
