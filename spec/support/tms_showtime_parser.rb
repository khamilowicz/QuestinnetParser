class TMSShowtime
  attr_accessor :remote_service_id, :theatre_id, :datetime
end

class TmsShowtimeParser
  include Questinnet::Show

  converter Questinnet::Converter::TMS::Showtime.new, source: :tms

  conversion(->{TMSShowtime.new}) do |showtime, object|
    object.remote_service_id = showtime[:remote_service_id]
    object.theatre_id = showtime[:theatre_id]
    object.datetime = DateTime.parse(showtime[:datetime])
  end

  download_config(:update) do |config|
    config.source = :tms
    config.path = 'v1'
    config.file_prefix = "movies/showings"
    config.type = :json
    config.params = {zip: 78702, startDate: Date.today.strftime("%Y-%m-%d")}
  end
end

class TMSCinema
  attr_accessor :remote_service_id, :remote_service_name, :city, :name, :address, :phone, :dolby_surround,
  :parking_lot, :disabled_access, :www, :air_conditioning, :street, :user, :city_id, :id
end

class RemoteCinemaService

  def initialize remote_service_name

  end

  def city params
    ::QuestinnetService.city params

  end

  def user_for params
    ::QuestinnetService.user_for params
  end

  def service_name
    ::QuestinnetService.service_name
  end
end

class TMSCinemaParser
  include Questinnet::Film

  converter Questinnet::Converter::TMS::Cinema.new, source: :tms

  conversion(->{TMSCinema.new}) do |params, cinema|
    params[:remote_service_id] = params.delete(:id).to_i
    remote_cinema_service = RemoteCinemaService.new(params[:remote_service_name])
    cinema.city = remote_cinema_service.city(q_id: params.delete(:city_id))
    cinema.user = remote_cinema_service.user_for(q_id: params[:remote_service_id])
    cinema.remote_service_name = remote_cinema_service.service_name
    params.each do |key, val|
      cinema.send "#{key}=", val
    end
  end

  download_config(:update) do |config|
    config.source = :tms
    config.path = 'v1'
    config.file_prefix = "theatres"
    config.type = :json
    config.params = {zip: 78702}
  end
end