class AiController < ApplicationController
  before_action :authenticate_user!

  def talk
    @entries = current_user.entries.order(created_at: :desc)
    # Normalize messages so they always use symbols
    session[:messages] ||= []
    session[:messages] = session[:messages].map(&:symbolize_keys)
    @messages = session[:messages]
  end

  def chat
    user_message = params.dig(:chat, :message)

    if user_message.present?
      client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: user_message }],
          max_tokens: 150
        }
      )

      ai_reply = response.dig("choices", 0, "message", "content") || "[no response]"

      # Store both user and AI messages as symbols
      session[:messages] ||= []
      session[:messages] << { role: :user, content: user_message }
      session[:messages] << { role: :journal, content: ai_reply }
    end

    redirect_to talk_path
  end
end
