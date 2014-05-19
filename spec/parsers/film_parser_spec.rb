#encoding: UTF-8

require "spec_helper"
require "ostruct"

describe "parser" do
  class Spoof < OpenStruct; end

  before(:all) do
    description_path =  File.join(Pathname.pwd.to_s, 'spec' , 'api', '/opisy.xml')
    descriptions =  File.read(description_path)
    @movies = FilmParser.parse xml: descriptions
  end

  def movies
    @movies
  end

  let(:cinema_paradiso){
    Spoof.new \
    title: 'Cinema Paradiso',
    id: 102,
    country: 'Francja, Włochy'
  }

  it "converts xml file with movies into Film objects" do
    movies.all?{|m| m.is_a? Film}.should be_true
  end

  context "parsed movies have right" do
    subject{ movies.find &Finder.like(id: 102)}

    [:title, :id, :country].each do |attr|
      its(attr){ should_not be_nil}
      its(attr){ should eq(cinema_paradiso.send attr)}
    end
  end
end