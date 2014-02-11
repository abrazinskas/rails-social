class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :update, :followers, :following]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  #redirect user if he is signed in and tried to request new/create actions
  before_filter :signed_in_user_redirect, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page],per_page: 20)
  end

  def new
    @user=User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App, #{@user.name}!"
      redirect_to @user #, notice: 'User was successfully created.'
    else
      render 'new'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success]='Your account was successfully updated!'
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy unless current_user.id==params[:id]
    flash[:success] = "User destroyed."
    redirect_to users_path
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end


  def signed_in_user_redirect
    redirect_to root_path if signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
