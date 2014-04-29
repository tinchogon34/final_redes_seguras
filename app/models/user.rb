require 'digest/sha2'

class User < ActiveRecord::Base
  before_create :encrypt_password

  attr_accessor :password, :password_confirmation, :email_confirmation

  validates :username, :email, presence: true
  validates :password, :email, confirmation: { on: :create } 
  validates :password, :password_confirmation, :email_confirmation, presence: { on: :create }

  has_one :coord_card, dependent: :destroy

  def valid_password?(password)
    self.encrypted_password == (Digest::SHA2.new << password).to_s
  end

  def confirmed?
    self.confirm_token.nil?
  end

  private

  def encrypt_password
    self.encrypted_password = (Digest::SHA2.new << self.password).to_s
  end
end
