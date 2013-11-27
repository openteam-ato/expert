# encoding: utf-8

class Request < ActiveRecord::Base
  attr_accessible :email, :message, :name, :phone

  validates_presence_of :name, :email, :message
  validates_format_of :name, :with => /\A([ёЁа-яА-Я]+\s*)+\z/
  validates :email, :email_format => { :message => I18n.t('activerecord.errors.messages.invalid') }
end

# == Schema Information
#
# Table name: requests
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  phone      :string(255)
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

