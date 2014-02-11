class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy


  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10) if signed_in?
      render :template => 'static_pages/home'
    end
  end

  def destroy
    #@micropost.destroy

    @micropost.destroy
    flash[:success]='Post was successfully deleted!'
    redirect_to root_path
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def micropost_params
    params.require(:micropost).permit(:content)
  end

  private
  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end

end