class AiController < ApplicationController
  before_action :authenticate_user!

  def talk
    @entries       = current_user.entries.order(created_at: :desc)
    @conversations = current_user.conversations.order(created_at: :desc)

    # Pick a conversation if provided or remembered; do NOT auto-create.
    picked_id      = params[:conversation_id].presence || session[:conversation_id]
    @conversation  = picked_id.present? ? current_user.conversations.find_by(id: picked_id) : nil

    # Keep session in sync (or clear if none).
    session[:conversation_id] = @conversation&.id

    @messages = @conversation ? @conversation.chat_messages.order(:created_at) : []
  end

  def chat
    user_message = params.dig(:chat, :message).to_s.strip
    if user_message.blank?
      redirect_to talk_path(conversation_id: params[:conversation_id].presence || session[:conversation_id]),
                  alert: "Message can't be empty." and return
    end

    # Reuse current conversation, or create one if none is active yet.
    conversation = current_user.conversations.find_by(id: params[:conversation_id]) ||
                   current_user.conversations.find_by(id: session[:conversation_id]) ||
                   current_user.conversations.create!(title: default_title)

    session[:conversation_id] = conversation.id

    ChatMessage.create!(user: current_user, conversation: conversation, role: "user",     content: user_message)
    ai_reply = call_openai(user_message, conversation)
    ChatMessage.create!(user: current_user, conversation: conversation, role: "journal",  content: ai_reply)

    redirect_to talk_path(conversation_id: conversation.id)
  end

  private

  def default_title
    "Conversation #{Time.current.strftime('%Y-%m-%d %H:%M')}"
  end

  def call_openai(user_message, conversation)
    begin
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

      history = conversation.chat_messages.order(:created_at).last(10).map do |m|
        {
          role:    (m.role == "user" ? "user" : "assistant"),
          content: m.content.to_s
        }
      end

      payload = {
        model: "gpt-4o-mini",
        messages: history + [{ role: "user", content: user_message }]
      }

      response = client.chat(parameters: payload)
      response.dig("choices", 0, "message", "content") || "…"
    rescue => e
      Rails.logger.error("AI error: #{e.class}: #{e.message}")
      "Sorry, I couldn't think of a reply just now."
    end
  end
end
