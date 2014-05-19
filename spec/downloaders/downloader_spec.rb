# encoding: UTF-8
require "spec_helper"

describe "Downloader" do
  context "raises error when" do
    Attrs = %w{username password address}
    Downloader = Questinnet::Downloader::Downloader

    Attrs.each do |attr|
      it "#{attr} is not set" do
        Downloader.config do |config|
          (Attrs - [attr]).each do |at|
            config.send "#{at}=", 'sth'
          end
        end

        expect{ Downloader.new }
        .to raise_error("#{attr.capitalize} not set")

      end
    end
  end

  it "can be configured with block" do
    Downloader.config do |c|
      c.username = 'some name'
      c.password = 'some password'
      c.address = 'some address'
      c.file_prefix = 'default'
    end

    TestShow.downloader.username.should eq('some name')
    TestShow.downloader.address.should eq('some address')
    TestShow.downloader.password.should eq('some password')
  end

  context "when configured" do

    before do
      Downloader.config do |c|
        c.username = 'Anonymous'
        c.password = ''
        c.address = address
        c.file_prefix = 'default'
      end
      set_up_server
    end

    after do
      tear_down_server
    end

    before(:each) do
      @path = "/spec/api"
      @downloader = Downloader.new path: @path
    end

    it "loads content of file from ftp server" do
      temp = @downloader.get("smallfile.xml")
      temp.should eq(File.read('spec/api/smallfile.xml'))
    end

    describe "filename" do
      context "has name with suffix of given movie week" do
        before(:each) do
          @wednesday = Date.new(2013, 12, 17)
        end

        it "and prefix set on downloader when not explicit" do
          @downloader.filename(day: @wednesday).should eq('default20131213.xml')
        end

        it "and next movie week if not provided" do
          pending 'something with conditions..'
          Date.stub(today: Date.new(2013, 12, 30))
          @downloader.filename(prefix: 'kina').should eq('kina20140103.xml')
        end

        it "and xml by default" do
          @downloader.filename(prefix: 'kina', day: @wednesday).should eq('kina20131213.xml')
        end

        it "and csv if set" do
         @downloader.filename(prefix: 'kina', day: @wednesday, format: :csv).should eq('kina20131213.csv')
       end
     end
   end
 end
end