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
      upload = Upload.new
      upload.object_key = Upload.generate_s3_key(params)      
      test=Upload.s3_bucket.presigned_post(:key => "photos/test.jpg?partNumber=PartNumber&uploadId=UploadId")

      
      upload.s3_object.multipart_upload do |upload|
        debugger
        upload.add_part("b" * 57152)
      end
      
      if upload.s3_exists?
        logger.warn "already_exist_s3 #{upload.object_key}"
        render json: {status: "already_exist"}
      else
        upload.save!
        render json: {status: 'upload_ready', upload: upload.attributes}
        session.delete(:_s3_browser_multipart_random)
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
