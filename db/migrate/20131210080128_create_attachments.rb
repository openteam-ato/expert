class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer :request_id
      t.timestamps
    end
    add_attachment :attachments, :file
  end

  def self.down
    drop_table :attachments
  end
end
