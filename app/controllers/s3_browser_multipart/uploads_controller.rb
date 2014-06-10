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
        render json: {status: 'upload_ready', 
          secure_random: params[:secureRandom], name: params[:name],
          chunk_size: upload.chunk_size,
          upload: { url: upload_sign.url.to_s, upload_id: upload.id,
            fields: upload_sign.fields, 
            part_prefix: upload.part_prefix
          }}
      end
    end

    def update
      @object = Upload.find(params[:id])
      begin
        @object.finish_upload
        session.delete(:_s3_browser_multipart_random)
        render json: {status: 'assemble_success', object_key: @object.object_key }
      rescue Exception => exc 
        logger.error exc.message
        render json: {status: 'assemble_failed', 
          error_message: exc.message }
      end
      @object.clean rescue logger.error $!.message
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
