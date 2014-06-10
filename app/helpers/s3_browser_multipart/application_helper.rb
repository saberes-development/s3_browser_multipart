module S3BrowserMultipart
  module ApplicationHelper
    #Create tags for upload files
    def file_uploader(args={})
      secure_random = session[:_s3_browser_multipart_random] = 
        SecureRandom.base64(24).gsub(/\//,'-')
      options = S3BrowserMultipart::Engine.config.
        default_options.merge(args)
      options[:secure_random]=secure_random
      file_field_tag :file_uploader_field, class: 'file_uploader', 
        multiple: options[:multiple], data: options
    end
    def upload_progress()
      render partial: 's3_browser_multipart/uploads/progress'
    end
  end
end
