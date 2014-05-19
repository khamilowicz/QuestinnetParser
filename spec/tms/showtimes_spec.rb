require "spec_helper"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end

Questinnet::Downloader::Downloader.config do |config|
  config.source = :tms
  config.method = :json
  config.address = "http://data.tmsapi.com"
  config.password = ENV["POSTERRO_TMS_KEY"]
end

describe "TMCCinema converter" do
  it "converts tms format into posterro cinema" do
    pending "in progress"
    VCR.turn_off!
    WebMock.allow_net_connect!
    cinemas = TMSCinemaParser.retrieve
  end
end

describe "TMS downloader" do
  let(:showings){ File.read("./spec/api/tms_showings", encoding: 'us-ascii') }

  it "downloads json data" do
    pending 'works, but files are diffrent for some reason...'
    address = "http://data.tmsapi.com"
    path = "v1/movies/showings"
    start = "2014-02-13"
    zip = 78701
    key = ENV["POSTERRO_TMS_KEY"]
    data = ""
    VCR.use_cassette(:tms_showings) do
      data = Questinnet::Downloader::JSONDownloader.
      new(address: address, path: path, params: {api_key: key, startDate: start, zip: zip}).get
    end
    data.should eq(showings)
  end

  it "parses output" do
    pending "key is no longer valid :("
    VCR.turn_off!
    WebMock.allow_net_connect!
    showtimes = TmsShowtimeParser.retrieve
    showtimes.first.should be_a(TMSShowtime)
    showtimes.first.datetime.should be_a(DateTime)
    WebMock.disable_net_connect!
  end
end