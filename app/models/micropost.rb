# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  belongs_to :user
  default_scope order: 'microposts.created_at DESC'

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    #followed_user_ids = user.followed_user_ids
    #where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    #followed_user_ids = user.followed_user_ids


    # faster ruby sql statement
    followed_user_ids = "SELECT followed_id FROM relationships
WHERE follower_id = :user_id"

    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end
