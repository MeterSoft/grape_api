class User < ActiveRecord::Base
  attr_accessible :password, :role, :username

  has_many :pages

  validates_presence_of :username, :password, :role
  validates_uniqueness_of :username

  def admin?
    role == 'admin'
  end
end
