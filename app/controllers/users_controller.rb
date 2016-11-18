class UsersController < ApplicationController

   def welcome
   end

   def logout
      flash[:notice]  = "Successfully Logged Out!"
      session[:user_id] = nil
      cookies.delete :auth_token
      cookies.delete :typo_user_profile
      redirect_to :action => 'welcome'
   end

   def signup
      if request.xhr?
         flash[:ajax] = true
      else
         flash[:ajax] = false
      end
      if request.post?
         if params[:confirm_password] == params[:password]
            new_params = signup_params()
            user = User.new(new_params)
            if user.save!
               session[:user_id] = user.id
               redirect_to root_path
            else
               flash[:error] = "Please ensure all boxes are filled."
            end
         else
            flash[:error] = "Your Passwords do not match!"
         end
      end
   end

   def login
      if request.xhr?
         flash[:ajax] = true
      else
         flash[:ajax] = false
      end
      if request.post?
         user = User.authenticate(params[:username], params[:password])
         if user
            session[:user_id] = user.id
            redirect_to root_path
         else
            flash[:error] = 'No Login Found, Try Again!'
         end
      end
   end


   protected

   def signup_params
      params.permit(:username, :password, :name, :email).except(:confirm_password)
   end

   def login_params
      params.permit(:username, :password)
   end

   # def signup_params
   #    devise_parameter_sanitizer.permit(:username, :password, :name, :email).except(:confirm_password)
   # end
   #
   # def login_params
   #    devise_parameter_sanitizer.permit(:username, :password)
   # end

end