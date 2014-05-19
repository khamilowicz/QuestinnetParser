class ShowParser

  include Questinnet::Converter::Show

  conversion do |params|
    s = Show.new
    s.cinema_id = params[:cinema_id]
    s.start_date = params[:start_date]
    s.end_date = params[:end_date]
    s.hours = params[:hours]
    s.movies = params.fetch(:movies)[:movie]
    s
  end

  def self.extract_movies movies
    movies = movies[:movies][:movie]
    case movies.class.to_s
    when "Hash" then [movies]
    when "Array" then movies.map{|m| m}
    end
  end

  def self.extract_movie_ids movies
    extract_movies(movies).map{|m| m[:movie_id]}
  end

end