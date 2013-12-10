class Attachment < ActiveRecord::Base
  has_attached_file :file, :storage => :elvfs, :elvfs_url => Settings['storage']['url']
end

# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  request_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  file_url          :text
#

