module CinemaParser

  include Questinnet::Converter::Cinema

  conversion do |params|
    c = Cinema.new
    c.name = params[:name]
    c.id = params[:id]
    c.street = params[:street]
    c
  end
end