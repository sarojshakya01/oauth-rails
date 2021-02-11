# frozen_string_literal: true

class User < ApplicationRecord
  include ActiveModel::Validations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable,
         :database_authenticatable,
         :registerable,
         :timeoutable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :lockable,
         :password_expirable,
         :password_archivable

  has_many :access_grants,
           class_name: "Doorkeeper::AccessGrant",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: "Doorkeeper::AccessToken",
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  # has_many :oauth_applications,
  #          class_name: "Doorkeeper::Application",
  #          as: :owner

  # Basic usage.  Defaults to minimum entropy of 18 and no dictionary checking
  # validates :password, password_strength: true
  # # Minimum entropy can be specified as min_entropy
  # validates :password, password_strength: {min_entropy: 40}
  # # Specifies that we want to use dictionary checking
  # validates :password, password_strength: {use_dictionary: true}
  # # Specifies the minimum size of things that should count as words.  Defaults to 4.
  # validates :password, password_strength: {use_dictionary: true, min_word_length: 6}
  # # Specifies that we want to use dictionary checking and adds 'other', 'common', and 'words' to the dictionary we are checking against.
  # validates :password, password_strength: {extra_dictionary_words: ['other', 'common', 'words'], use_dictionary: true}
  # # You can also specify a method name to pull the extra words from
  # validates :password, password_strength: {extra_dictionary_words: ['extra', 'words', 'here', 'too'], use_dictionary: true}
  # # Alternative way to request password strength validation on a field
  # validates_password_strength :password

  def cc_admin
    false
  end
end