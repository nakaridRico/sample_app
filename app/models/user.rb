require 'digest'
class User < ActiveRecord::Base
  attr_accessor   :password, :password_confirmation
  attr_accessible :name, :email, :password, :password_confirmation, :salt

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true, 
  :length   => { :maximum => 50 }
  validates :email, :presence => true, 
  :format           => { :with => email_regex },
  :uniqueness       => { :case_sensitive => false }
  validates_presence_of :password
  validates_length_of   :password, :within => 6..40
  validates_presence_of :password_confirmation
  validates_length_of   :password_confirmation, :within => 6..40  

  validate :matching_passwords

  before_save :encrypt_password

  def matching_passwords 
    errors.add(:expiration_date, "can't be in the past") unless
    password == password_confirmation
  end


  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  class << self
    def authenticate(email, submitted_password)
      user = find_by_email(email)
      (user && user.has_password?(submitted_password)) ? user : nil
    end
 
  
  def authenticate_with_salt(id, cookie_salt)
        user = find_by_id(id)
        (user && user.salt == cookie_salt) ? user : nil
      end
 end
 
  private

  def encrypt_password
    self.salt = make_salt
    self.encrypted_password = encrypt(self.password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end  

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end 

  private
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end







# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#

