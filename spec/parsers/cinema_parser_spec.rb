#encoding: UTF-8

require "spec_helper"
require "ostruct"

describe "parser" do
  class Spoof < OpenStruct; end

  before(:all) do
    cinemas_path =  File.join(Pathname.pwd.to_s, 'spec' , 'api', '/kina.xml')
    cinemas_descriptions =  File.read(cinemas_path)
    @cinemas = CinemaParser.parse xml: cinemas_descriptions
  end

  def cinemas
    @cinemas
  end

  let(:forum_cinema){
    Spoof.new \
    name: "Forum",
    id: 1,
    street: 'Legionowa 5'
  }

  it "converts xml file with cinemas into Cinema objects" do
    cinemas.all?{|m| m.is_a? Cinema}.should be_true
  end

  context "parsed cinemas have right" do
    subject{ cinemas.find &Finder.like(id: 1)}

    [:name, :id, :street].each do |attr|
      its(attr){ should_not be_nil}
      its(attr){ should eq(forum_cinema.send attr)}
    end
  end
end