class Page < ActiveRecord::Base
  attr_accessible :content, :published_on, :title, :user_id

  belongs_to :user

  validates_presence_of :title, :content, :user_id
  validates_uniqueness_of :title
  validates_associated :user

  scope :published, -> { where("published_on IS NOT NULL OR published_on <= ?", Time.now) }
  scope :unpublished, -> { where("published_on IS NULL OR published_on > ?", Time.now) }
  scope :desc, -> { order("published_on DESC") }
end
