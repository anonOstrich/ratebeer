class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :cache_does_not_contain_data_or_it_is_too_old

  def current_user
    return nil if session[:user_id].nil?

    User.find(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'you should be signed in' if current_user.nil?
  end

  def ensure_that_admin
    ensure_that_signed_in
    redirect_to current_user, notice: 'only permitted for admin users' if !current_user.admin?
  end
end
