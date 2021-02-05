# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :registerable,
         :invitable,
         :timeoutable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :lockable,
         :password_expirable,
         :password_archivable,
         :zxcvbnable

  has_many :access_grants,
           class_name: "Doorkeeper::AccessGrant",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: "Doorkeeper::AccessToken",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :oauth_applications,
           class_name: "Doorkeeper::Application",
           as: :owner


  # Optionally add more weak words to check against:
  def weak_words
    ['Test', self.name, self.account_name]
  end

end