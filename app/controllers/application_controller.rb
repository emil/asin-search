class ApplicationController < ActionController::Base
  before_action :set_fake_login

  private

  def set_fake_login
    # Set user, account context
    # (needed in Amazon::Product#save)
    RequestRegistry.current_user = User.first
    RequestRegistry.current_account = User.first.account
  end
end
