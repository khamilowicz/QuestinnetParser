class ConversionProcShowParser
 include Questinnet::Converter::Show

 conversion(->{Show.new}) do |params, object|
  object.cinema_id = params[:cinema_id]
  object.start_date = params[:start_date]
  object.end_date = params[:end_date]
  object.hours = params[:hours]
  object.movies = params.fetch(:movies)[:movie]
end
end