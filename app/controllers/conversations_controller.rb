class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def create
    conv = current_user.conversations.create!(title: "Conversation #{Time.current.strftime('%Y-%m-%d %H:%M')}")
    session[:conversation_id] = conv.id
    redirect_to talk_path(conversation_id: conv.id), notice: "New conversation started."
  end

  def destroy
    conv = current_user.conversations.find(params[:id])
    conv.destroy
    session[:conversation_id] = nil if session[:conversation_id].to_i == conv.id
    redirect_to talk_path, notice: "Conversation deleted."
  end
end
