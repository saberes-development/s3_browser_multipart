# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :s3_browser_multipart_upload_part, :class => 'UploadPart' do
    upload_id 1
    file_key "MyString"
  end
end
