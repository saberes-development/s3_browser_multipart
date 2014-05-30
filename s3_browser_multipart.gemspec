$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "s3_browser_multipart/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "s3_browser_multipart"
  s.version     = S3BrowserMultipart::VERSION
  s.authors     = ["Jair Garcia"]
  s.email       = ["jair.garcia@saberes.com"]
  s.homepage    = "http://www.saberes.com"
  s.summary     = "Upload big files to S3 from web browser with multipart"
  s.description = "Allow to upload big files direct from web browser to s3\
   using multipart feature (in chuncks)"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.18"
  s.add_dependency "aws-sdk", "~> 1.41"

  s.test_files = Dir["spec/**/*"]
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
