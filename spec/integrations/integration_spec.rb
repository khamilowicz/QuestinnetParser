require 'spec_helper'
require_relative "./downloader_initializer"

describe "Class with configured downloader and parser" do
  before do
    set_up_server
  end

  after do
    tear_down_server
  end

  before(:each) do
  end

  it "downloads and creates next week objects with #retrieve(:service)" do
    Date.stub(today: Date.new(2013,12,17))
    shows = TestShow.retrieve
    example_show = shows.first
    example_show.should be_a(TestShow)
    example_show.cinema_id.should eq("1")
    example_show.start_date.should eq(Date.new(2013,12,26))
  end
end