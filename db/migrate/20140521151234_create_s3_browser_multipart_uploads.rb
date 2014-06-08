class CreateS3BrowserMultipartUploads < ActiveRecord::Migration
  def change
    create_table :s3_browser_multipart_uploads do |t|
      t.string :upload_id
      t.string :object_key
      t.string :state, :default => 'uploading'
      t.integer :file_size
      t.integer :file_chunk_size
      t.timestamps
    end
  end
end
