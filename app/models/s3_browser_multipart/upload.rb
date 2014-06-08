require 'aws-sdk'
module S3BrowserMultipart
  class Upload < ActiveRecord::Base
    # attr_accessible :title, :body
    attr_accessor :multipart_upload, :s3_object, 
      :presigned_post, :params

    before_create :create_multipart_upload

    def initialize(value = {})
      super(nil)
      self.params = {}
      value.each{|key, value| self.params[key.tableize.singularize.to_sym]=value}
      self.object_key = Upload.generate_s3_key(self.params)
      self.s3_object= Upload.get_s3_object(self.object_key)
      self.file_size = params[:size]
      self.file_chunk_size = params[:chunk_size]
    end

    #Confirm what happen if another upload is in progress for the same key
    def s3_exists?
      self.s3_object.exists?
    end



    #Create the multipart upload in amazon s3
    def create_multipart_upload
      self.s3_object||= Upload.get_s3_object(self.object_key)
      self.multipart_upload = s3_object.multipart_upload
      self.upload_id = self.multipart_upload.upload_id
      logger.warn "Created multipart_upload_id: #{self.upload_id} object_key: #{self.object_key}"
    end

    #generate s3 key
    def self.generate_s3_key(params)
      file_name = I18n.interpolate(S3BrowserMultipart::Engine.config.
        default_internal_options[:s3_path], params)
    end

    def chunk_size
      (params['chunk_size']||5242880).to_i
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

    def generate_part_upload_signature
      Upload.s3_bucket.
        presigned_post(:content_length => 1..self.chunk_size,
          :expires=> DateTime.now+1.days, secure: true, success_action_status: 200).
          where(:key).starts_with("#{self.object_key}_part_")
    end
  end
end
