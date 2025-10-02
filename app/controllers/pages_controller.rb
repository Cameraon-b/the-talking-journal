class PagesController < ApplicationController
  def home
  end

  def about
  end

  def talk
    @entries = current_user.entries if user_signed_in?
  end

end
