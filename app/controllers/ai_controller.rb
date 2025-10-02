class AiController < ApplicationController
  before_action :authenticate_user!

  def talk
    # Load the current user's entries so the sidebar has something to show
    @entries = current_user.entries.order(created_at: :desc)

    # Load conversation messages from the session
    @messages = session[:messages] || []
  end

  def chat
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    session[:messages] ||= []
    session[:messages] << { role: "user", content: params[:message] }

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          { role: "system", content: "You are The Talking Journal, a reflective and helpful guide." },
          *session[:messages]
        ]
      }
    )

    ai_reply = response.dig("choices", 0, "message", "content")
    session[:messages] << { role: "assistant", content: ai_reply }

    # Keep sidebar entries visible after sending a message
    @entries = current_user.entries.order(created_at: :desc)
    @messages = session[:messages]

    render :talk
  end
end
