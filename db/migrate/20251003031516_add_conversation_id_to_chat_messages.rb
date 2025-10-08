class AddConversationIdToChatMessages < ActiveRecord::Migration[8.0]
  def change
    add_reference :chat_messages, :conversation, null: false, foreign_key: true
  end
end
