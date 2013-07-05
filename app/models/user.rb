class User < ActiveRecord::Base
  attr_accessible :password, :role, :username

  has_one :page

  validates_presence_of :username, :password, :role
  validates_uniqueness_of :username
end
