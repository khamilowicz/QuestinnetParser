require "spec_helper"


describe "when module Downloader is included in class" do

  IncludedDownloader = Class.new
  IncludedDownloader.send :include, Questinnet::Downloader

  it "raises error if not configured" do
    pending 'cannot check it before configuration'
    expect{ IncludedDownloader.new}.to raise_error "No downloaders configured"
  end

  Questinnet::Downloader::Downloader.config do  |c|
    c.username = 'Anonymous'
    c.password = ''
    c.address = address
  end

  IncludedDownloader.download_config do |config|
    config.path = 'spec/api'
    config.file_prefix = 'someprefix'
  end

  describe "is configured" do
    before do
      set_up_server
    end

    after do
      tear_down_server
    end

    before(:each) do
      @id = IncludedDownloader
    end

    it "with #download_config method" do
      @id.downloader.path.should eq 'spec/api'
    end

    it "can download with #download" do
      Date.stub(today: Date.new(2013, 12, 17))
      @id.download.values.first.values.first.should eq(['Good job'])
    end

    it "with diffrent params than other classes" do
      Other = Class.new
      Other.send :include, Questinnet::Downloader
      Other.download_config do |config|
        config.path = 'other path'
        config.file_prefix = 'other prefix'
      end
      Other.downloader.should_not be(@id.downloader)
      Other.downloader.file_prefix.should_not eq(@id.downloader.file_prefix)
      Other.downloader.file_prefix.should eq('other prefix')
    end
  end
end
