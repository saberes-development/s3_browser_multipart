require 'spec_helper'

module S3BrowserMultipart
  describe Upload do
    before do
      @object = Upload.new
    end
    it "generate_s3_key" do
      expect(Upload.generate_s3_key("name"=> 'file.pdf', 
        "type"=> 'application/pdf', 
        "secureRandom"=> 'abc123')).to be_eql("/abc123/file.pdf")
    end
    it "get_s3_object" do
      s3_object = double('s3object')
      allow(Upload).to receive(:s3_bucket) do 
        bucket=double('S3::Bucket')
        bucket.stub(objects: {"/abc123/file.pdf"=>s3_object})
        bucket
      end
      expect(Upload.get_s3_object("/abc123/file.pdf")).to equal(s3_object)
    end

    it 's3_exists?' do 
      @object.object_key = "/abc123/file.pdf"
      @object.s3_object = double("S3Object", "exists?"=> true)
      expect(@object.s3_exists?).to be_true
    end

    it "create_multipart_upload" do 
      @object.object_key = "/abc123/file.pdf"
      Upload.stub :get_s3_object do |key|
        double("S3Object", "exists?"=> true,
          multipart_upload: double("S3Multipart",
            upload_id: 'abcdefg'
          )
        )
      end
      @object.create_multipart_upload
      expect(@object.upload_id).to be_eql 'abcdefg'
    end

  end
end
