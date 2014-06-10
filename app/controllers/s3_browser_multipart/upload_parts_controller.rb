require_dependency "s3_browser_multipart/application_controller"

module S3BrowserMultipart
  class UploadPartsController < ApplicationController
    before_filter :confirm_secure_random
   
    def create
      upload_part = parent_object.upload_parts.create!(file_key: params[:file_key])
      render json: {status: 'part_registered', part_number: upload_part.part_number}
    end

    private
    def confirm_secure_random
      parent_object_key_size = parent_object.object_key.size
      unless parent_object.object_key == params[:file_key].to_s[0..(parent_object_key_size-1)]
        logger.error("Signature do not match #{ parent_object.object_key} != #{params[:file_key].to_s[0..(parent_object_key_size-1)]}")
        render status: 401
        return false
      end
    end
    def parent_object
      @parent_object ||= Upload.find(params[:upload_id])
    end
  end
end
