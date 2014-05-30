require 'aws-sdk'
module S3BrowserMultipart
  class Upload < ActiveRecord::Base
    # attr_accessible :title, :body
    attr_accessor :multipart_upload, :s3_object

    before_create :create_multipart_upload

    #Confirm what happen if another upload is in progress for the same key
    def s3_exists?
      self.s3_object.exists?
    end

    def object_key=(value)
      self.attributes[:object_key]=value
      self.s3_object= Upload.get_s3_object(value)
    end

    #Create the multipart upload in amazon s3
    def create_multipart_upload
      self.s3_object = Upload.get_s3_object(self.object_key)
      self.multipart_upload = s3_object.multipart_upload
      self.upload_id = self.multipart_upload.upload_id
      logger.warn "Created multipart_upload_id: #{self.upload_id} object_key: #{self.object_key}"
    end

    #generate s3 key
    def self.generate_s3_key(params)
      tableize_params = {}
      params.each{|key, value| tableize_params[key.tableize.singularize.to_sym]=value}
      file_name = I18n.interpolate(S3BrowserMultipart::Engine.config.
        default_internal_options[:s3_path], tableize_params)
    end

    #get s3 object from key
    def self.get_s3_object(key)  
      Upload.s3_bucket.objects[key]
    end

    #Connect  with a bucket in s3
    ##UNTESTED
    def self.s3_bucket
      AWS.config(S3BrowserMultipart::Engine.config.s3_config.
        slice(:access_key_id,:secret_access_key, :region, 
        :s3_server_side_encryption))
      @@s3 ||= AWS::S3.new
      @@bucket ||= @@s3.buckets[S3BrowserMultipart::Engine.
        config.s3_config[:bucket_name]]
    end
  end
end
