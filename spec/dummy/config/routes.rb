Rails.application.routes.draw do

  mount S3BrowserMultipart::Engine => "/s3_browser_multipart"
end
