class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    conversation = current_user.conversations.create!(title: "Conversation #{Time.current.strftime('%Y-%m-%d %H:%M')}")
    redirect_to talk_path(conversation_id: conversation.id)
  end

  def destroy
    conversation = current_user.conversations.find(params[:id])
    conversation.destroy
    redirect_to talk_path, notice: "Conversation deleted"
  end
end
