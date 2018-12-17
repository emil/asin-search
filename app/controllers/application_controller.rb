class ApplicationController < ActionController::Base
  before_action :set_fake_login

  protected

  def not_found
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  private

  def set_fake_login
    # Set user, account context
    # (needed in Amazon::Product#save)
    RequestRegistry.current_user = User.first
    RequestRegistry.current_account = User.first.account
  end
end
