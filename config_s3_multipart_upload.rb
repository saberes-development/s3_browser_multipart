module S3BrowserMultipart
  class Engine < Rails::Engine
      config.s3_config = {
        access_key_id: "AWS_S3_ACCESS_KEY", 
        secret_access_key: "AWS_S3_SECRET_KEY", 
        bucket_name: "AWS_S3_BUCKET_NAME", 
        region: nil, 
        :server_side_encryption => nil
      } 
  end
end
