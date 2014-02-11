class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if signed_in?
    #@feed_items = current_user.feed if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page],per_page: 10) if signed_in?
  end

  def help
  end

  def about
  end
end
