class AiController < ApplicationController
  before_action :authenticate_user!

  def talk
    @entries = current_user.entries.order(created_at: :desc)
    @conversations = current_user.conversations.order(created_at: :desc)
    @conversation = if params[:conversation_id]
                      current_user.conversations.find_by(id: params[:conversation_id])
                    else
                      @conversations.first
                    end
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

    # Save user's message
    @conversation.chat_messages.create!(user: current_user, role: :user, content: user_message)

    # Add "typing..." placeholder
    placeholder = @conversation.chat_messages.create!(
      user: current_user,
      role: :journal,
      content: "The Journal is typing..."
    )

    # Immediately render Turbo update so typing indicator appears
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "chat-messages",
          partial: "ai/chat_window",
          locals: { conversation: @conversation, messages: @conversation.chat_messages.order(:created_at) }
        )
      end
      format.html { redirect_to talk_path(conversation_id: @conversation.id) }
    end

    # Fetch the AI reply in the background
    Thread.new do
      begin
        client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
        response = client.chat(
          parameters: {
            model: "gpt-4o-mini",
            messages: [{ role: "user", content: user_message }],
            temperature: 0.7
          }
        )
        ai_reply = response.dig("choices", 0, "message", "content")
        placeholder.update!(content: ai_reply)

        # Broadcast Turbo Stream update to refresh messages live
        Turbo::StreamsChannel.broadcast_replace_to(
          current_user,
          target: "chat-messages",
          partial: "ai/chat_window",
          locals: { conversation: @conversation, messages: @conversation.chat_messages.order(:created_at) }
        )

      rescue => e
        placeholder.update!(content: "⚠️ Error: #{e.message}")
      end
    end
  end
end


