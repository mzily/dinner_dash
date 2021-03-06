class SessionsController < ApplicationController
  def new
    redirect_to items_path if current_user
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      if current_admin?
        redirect_to admin_path(current_user)
      else
        redirect_to cart_path
      flash[:notice] = "Welcome, #{user.full_name}"
      end
    else
      flash[:notice] = "Invalid login."
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to items_path
  end
end
