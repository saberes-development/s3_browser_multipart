module S3BrowserMultipart
  class Engine < ::Rails::Engine
    isolate_namespace S3BrowserMultipart
    engine_name 's3_browser_multipart'
    initializer 'abaco_oath_client' do 
      unless config.respond_to? :s3_config
        config.s3_config = {
          access_key_id: ENV['ACCESS_KEY_ID'],
          secret_access_key: ENV['SECRET_ACCESS_KEY'],
          bucket_name: ENV['BUCKET_NAME'], 
          region: ENV['REGION'], 
          :server_side_encryption => ENV['BUCKET_NAME']
        } 
      end

      unless config.respond_to? :default_options
        config.default_options = {
          max_file_size: 1.gigabyte, 
          allowed_types: nil,
          chunk_size: 5.megabytes,
          multiple: false #not soported yet
        } 
      end
      #Security
      unless config.respond_to? :default_internal_options
        config.default_internal_options = {
          s3_path: "/%{secure_random}/%{name}" 
        } 
      end

    end

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        app.config.paths["db/migrate"] += config.paths["db/migrate"].expanded
      end
    end

    initializer 's3_browser_multipart.app_controller' do |app|
      #Rails.logger.error "App: "+app.inspect
      ActiveSupport.on_load(:action_controller) do
        helper S3BrowserMultipart::ApplicationHelper
      end
    end
  end
end
