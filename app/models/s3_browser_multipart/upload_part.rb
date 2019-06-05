module S3BrowserMultipart
  class UploadPart < ActiveRecord::Base
    attr_accessible :file_key, :upload_id
    attr_accessor :part_number
    belongs_to :upload
    after_create :assemble_part
    before_destroy :clean_s3

    def assemble_part
      prefix_size = (self.upload.object_key+'_part_').size
      self.part_number = self.file_key[prefix_size..-1].to_i
      self.upload.assemble_part(self.full_s3_name, part_number)
    end

    def full_s3_name
      "#{Upload.s3_bucket.name}/#{self.file_key}"
    end

    def clean_s3
      Rails.logger.info "Cleaning part #{self.file_key}"
      Upload.s3_bucket.objects[self.file_key].delete rescue Rails.logger.error $!.message
    end

  end
end
