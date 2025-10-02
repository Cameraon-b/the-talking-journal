class AiController < ApplicationController
  before_action :authenticate_user!

  def talk
    # Load this user’s saved chat history from DB
    @entries = current_user.entries.order(created_at: :desc)
    @messages = current_user.chat_messages.order(created_at: :asc)
  end

  def chat
    user_message = params[:chat][:message]

    if user_message.present?
      # Save the user’s message
      current_user.chat_messages.create!(role: "user", content: user_message)

      # Call OpenAI
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            { role: "system", content: "You are The Talking Journal, a supportive reflective AI." },
            { role: "user", content: user_message }
          ]
        }
      )

      ai_reply = response.dig("choices", 0, "message", "content")

      # Save the AI’s reply
      current_user.chat_messages.create!(role: "journal", content: ai_reply)
    end

    redirect_to talk_path
  end

  def clear
    current_user.chat_messages.destroy_all
    flash[:notice] = "Conversation cleared."
    redirect_to talk_path
  end
end
