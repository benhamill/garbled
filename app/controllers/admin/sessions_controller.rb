class Admin::SessionsController < ApplicationController
  layout 'login'

  def show
    if using_open_id?
      create
    else
      redirect_to :action => 'new'
    end
  end

  def new
  end

  def create
    return successful_login if allow_login_bypass? && params[:bypass_login]
    authenticate_with_open_id(params[:openid_url]) do |result, identity_url|
      if result.missing?
        flash.now[:error] = "Sorry, the OpenID server couldn't be found"
      elsif result.canceled?
        flash.now[:error] = "OpenID verification was canceled"
      elsif result.failed?
        flash.now[:error] = "Sorry, the OpenID verification failed"
      elsif result.successful?
        if config.author_open_ids.include?(URI.parse(identity_url))
          return successful_login
        else
          flash.now[:error] = "You are not authorized"
        end
      else
        flash.now[:error] = "OpenID verification failed in some unexpected way"
      end
      render :action => 'new'
    end
  end

  def destroy
    session[:logged_in] = false
    redirect_to('/')
  end

protected

  def successful_login
    session[:logged_in] = true
    redirect_to(admin_dashboard_path)
  end

  def allow_login_bypass?
    ["development", "test"].include?(RAILS_ENV)
  end
  helper_method :allow_login_bypass?
end
