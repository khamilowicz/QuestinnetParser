module FilmParser
  include Questinnet::Converter::Film

  conversion do |params|
    f = Film.new
    f.title = params[:title]
    f.id = params[:id]
    f.country = params[:country]
    f
  end
end