S3BrowserMultipart
=========
S3BrowserMultipart allow upload big files to amazon s3, in failing or slow internet connections. 
For this the web browser upload chunks (at least 5 mb) directly to amazon s3, and assemble them in amazon s3 using  [amazon S3 multipart upload](http://docs.aws.amazon.com/AmazonS3/latest/dev/mpuoverview.html)
If any upload fail it retry to upload automatically.

Requirements
------------

### Ruby and Rails
S3BrowserMultipart now requires Ruby version **>= 1.9.3** and Rails version **~ 3.2**, use ActiveRecord.

### HTML5 Web Browser
It requires [HTML5 file API](http://en.wikipedia.org/wiki/HTML5_File_API) for managing files and slicing them.

### Jquery
It requires jQuery version **>= 1.9.1** . 

Installing
------------

#### Add dependency.
Add to Gemfile: 

`gem 's3_browser_multipart', git: 'git@github.com:saberes-development/s3_browser_multipart.git'`

And run at console: 
`bundle install ` 

#### Migrations
The engine includes some migrations (Model S3BrowserMultipart::Upload and S3BrowserMultipart::UploadPart). Those migrations run automatically running: 
`rake db:migrate`

#### Include assets.

* In application.js add:  
 `//= require s3_browser_multipart/application`

* In application.css add (in comments):  
  `*= require s3_browser_multipart/application` 

#### Configuration
 At least configure [amazon S3 keys](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html) with enough permitions for posting and reading the s3 bucket.
 Create the file /config/initalizer/s3_multipart_upload.rb` with the following content replacing the keys.

 ```ruby
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
 ```
#### Routes
Add in /config/routes.rb: 
`mount S3BrowserMultipart::Engine => "/s3_browser_multipart"`

#### View
 In the view where the file upload is needed use the helper:
 `<%= file_uploader %>` for the file selector.
 `<%= upload_progress %>` for see the progress.

 * Customize fileUploadedEvent
For save the values after the process customize the event (this is an example')

 ```js
S3BrowserMultipart.prototype.fileUploaded = function(arg){
  var s3_key = arg.object_key;
  var upload_id = arg.upload_id;
}
 ```

Contributing
------------

There are a lot of work for doing.
* Js code is not tested
* Documentate code
* Restart upload after reload page
* Improve progress information (speed, ETA, etc.)
* Improve configuration
* Other proposal features

Credits
-------

![Saberes Group](http://www.saberes.com/assets/logo-bf337d09d20cb03b027db6847d812534.png)

S3BrowserMultipart was created by [Saberes.com](http://www.saberes.com/) and other contributors

License
-------

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file, remember to acknowledge the creators.
