# Request 'globals' - keep user, account on the Thread Local Storage
class RequestRegistry
  extend ActiveSupport::PerThreadRegistry

  attr_accessor :current_user, :current_account
end
