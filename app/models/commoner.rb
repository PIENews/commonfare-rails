class Commoner < ApplicationRecord
  include Authenticatable
  mount_uploader :avatar, AvatarUploader
  has_many :images
  has_many :stories
  has_many :comments
  has_many :memberships
  has_many :groups, through: :memberships
  has_many :join_requests
  has_many :messages

  before_destroy :archive_content

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def member_of?(group)
    self.groups.include? group
  end

  private
  def archive_content
    archive_commoner = User.find_by(email: ENV['ARCHIVE_COMMONER']).meta
    images.each do |image|
      image.commoner = archive_commoner
      image.save
    end
    stories.each do |story|
      story.commoner = archive_commoner
      story.save
    end
    comments.each do |comment|
      comment.commoner = archive_commoner
      comment.save
    end
  end
end
