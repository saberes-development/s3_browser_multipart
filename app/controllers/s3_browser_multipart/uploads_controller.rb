require_dependency "s3_browser_multipart/application_controller"
require 'aws-sdk'

module S3BrowserMultipart
  class UploadsController < ApplicationController
    before_filter :confirm_random
    
    #Create a new upload
    #!Max file size is insecure.
    #Response in JSON, and include a status
    # 
    #
    def create
      upload = Upload.new(params)
      if upload.s3_exists?
        logger.warn "already_exist_s3 #{upload.object_key}"
        render json: {status: "already_exist"}
      else
        upload.save!
        upload_sign = upload.generate_part_upload_signature
        session.delete(:_s3_browser_multipart_random)
        render json: {status: 'upload_ready', 
          secure_random: params[:secureRandom], name: params[:name],
          upload: { url: upload_sign.url.to_s,
            fields: upload_sign.fields
          }}
      end
    end

    protected

    #Filter that validate autheticity
    def confirm_random
      unless session[:_s3_browser_multipart_random] == params[:secureRandom]
        raise "SecureRandom not mismatch with session[:_s3_browser_multipart_random] in #{self.class.name}"
      end
    end
  end
end
