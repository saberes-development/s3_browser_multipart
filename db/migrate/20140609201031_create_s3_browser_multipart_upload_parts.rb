class CreateS3BrowserMultipartUploadParts < ActiveRecord::Migration
  def change
    create_table :s3_browser_multipart_upload_parts do |t|
      t.integer :upload_id
      t.string :file_key

      t.timestamps
    end
  end
end
