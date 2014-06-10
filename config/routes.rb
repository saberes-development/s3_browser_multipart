S3BrowserMultipart::Engine.routes.draw do
  resources :uploads do
    resources :upload_parts 
  end
end
