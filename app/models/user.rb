class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy

  validates :name, presence: true 
  validates :profile, length: { maximum: 200 }

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :comments, dependent: :destroy

  mount_uploader :image, ImageUploader

  has_many :posts

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationships', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  
  has_many :room_users
  has_many :rooms, through: :room_users
  has_many :messages

  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end
end
