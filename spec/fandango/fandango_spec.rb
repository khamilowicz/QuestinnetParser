require "spec_helper"

describe "In order to handle diffrent sources" do
  before do
    Downloader ||= Questinnet::Downloader::Downloader
  end
  context "and class with configured downloader and parser" do
    before do
      set_up_server
    end
    after do
      tear_down_server
    end
    #it ".retrive will use configured source and type of data" do
      #Date.stub(today: Date.new(2013, 12, 17))
      #out = FandangoTest.retrieve
      #titles = out.map(&:title)
      #titles.should include('Blizna', "Best Night Ever")
    #end
  end
  context "downloader can be configured separately for diffrent providers" do
    before(:each) do
      Downloader.config do |config|
        config.source = :a
        config.type = :type_a
        config.username = 'username_a'
        config.password = 'password_a'
        config.address = 'address_a'
      end
      Downloader.config do |config|
        config.source = :b
        config.type = :type_b
        config.username = 'username_b'
        config.password = 'password_b'
        config.address = 'address_b'
      end
    end

    it "with password, username and address" do
      downloader_a = Downloader.new source: :a
      downloader_b = Downloader.new source: :b
      {a: downloader_a, b: downloader_b}.each do |source, d|
        d.username.should eq( ['username', source.to_s].join('_'))
        d.password.should eq( ['password', source.to_s].join('_'))
        d.address.should eq( ['address', source.to_s].join('_'))
        d.type.should eq( ['type', source.to_s].join('_').to_sym)
      end
    end
  end
end