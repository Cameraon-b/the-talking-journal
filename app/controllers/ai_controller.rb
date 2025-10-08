class AiController < ApplicationController
  before_action :authenticate_user!

  def talk
    @entries = current_user.entries.order(created_at: :desc)

    # Load all conversations for sidebar
    @conversations = current_user.conversations.order(created_at: :desc)

    # Pick active conversation
    if params[:conversation_id]
      @conversation = current_user.conversations.find_by(id: params[:conversation_id])
    end

    # If no conversation selected, use most recent or nil
    @conversation ||= @conversations.first

    # Load messages for that conversation
    @messages = @conversation ? @conversation.chat_messages.order(:created_at) : []
  end

  def chat
    @conversation = current_user.conversations.find_by(id: params[:conversation_id]) ||
                    current_user.conversations.create!(title: "Conversation #{Time.current.strftime('%Y-%m-%d %H:%M')}")

    user_message = params.dig(:chat, :message)

    if user_message.blank?
      redirect_to talk_path(conversation_id: @conversation.id), alert: "Message can't be empty"
      return
    end

    # Save user message
    @conversation.chat_messages.create!(user: current_user, role: :user, content: user_message)

    # Get AI response
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: user_message }],
        temperature: 0.7
      }
    )
    ai_reply = response.dig("choices", 0, "message", "content")

    # Save AI response
    @conversation.chat_messages.create!(user: current_user, role: :journal, content: ai_reply)

    redirect_to talk_path(conversation_id: @conversation.id)
  end
end
