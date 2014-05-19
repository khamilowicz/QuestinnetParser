#encoding: UTF-8

require "spec_helper"
require "ostruct"

[ShowParser, ConversionProcShowParser].each do |klass|
describe "#{klass} parses" do
    class Spoof < OpenStruct; end
    before(:all) do
      shows_path = File.join(Pathname.pwd.to_s, 'spec' , 'api', '/seanse.xml')
      shows_descriptions = File.read(shows_path)
      @shows = klass.parse xml: shows_descriptions
    end

    def shows
      @shows
    end

    let(:show){
      Spoof.new \
      cinema_id: 1,
      start_date: Date.new(2013, 12, 26),
      end_date: Date.new(2013, 12, 26),
      hours: '14.30'
    }

    it "converts xml file with shows into Cinema objects" do
      shows.all?{|m| m.is_a? Show}.should be_true
    end

    context "shows with right" do
      subject{ shows.first }

      it "movie - nested content" do
        subject.movies.first[:movie_id].should eq('17031')

      end

      [:cinema_id, :start_date, :end_date, :hours].each do |attr|
        its(attr){ should_not be_nil}
        its(attr){ should eq(show.send attr)}
      end
    end
  end
end