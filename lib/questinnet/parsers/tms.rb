require_relative './common_translator'

module Questinnet
  module Converter
    module TMS
      class Showtime
        def extract_data data
          data.flat_map do |d|
            d["showtimes"].map do |e|
              {
                remote_service_id: d["tmsId"],
                datetime: e["dateTime"],
                theatre_id: e["theatre"]["id"],
              }
            end
          end
        end
      end

      class Showtime


        def extract_data data

          data.flat_map do |d|
            d["showtimes"].reduce({}) do |cinemas, showtime|
              date, hour = showtime["dateTime"].split("T")
              hour = hour.tr(":",".")
              cinema_id = showtime["theatre"]["id"]
              if cinemas.has_key?(cinema_id) && cinemas[cinema_id].last.fetch(:start_date) == date
                cinemas[cinema_id].last[:hours] += " " + hour
              else
                cinemas[cinema_id] ||= []
                cinemas[cinema_id] << {
                  id: d["rootId"],
                  cinema_id: showtime["theatre"]["id"],
                  start_date: date,
                  end_date: date,
                  hours: hour,
                  remote_service_name: 'tms',
                }
              end
              cinemas
            end.values.flatten
          end
        end
      end

      class Movie

        def runtime_to_minutes runtime
          runtime[2,2].to_i * 60 + runtime[5,2].to_i
        rescue
          nil
        end

        def cover_link cover
          "http://developer.tmsimg.com/#{cover}?api_key=#{ENV["POSTERRO_TMS_KEY"]}"
        end

        def parse_date d
          date = [d["releaseDate"], d["releaseYear"]].find(&:present?).to_s
          date += '-01-01' if date.length == 4
          date
        rescue
          nil
        end

        def extract_data data
          data.flat_map do |d|
            date = parse_date(d)
            {
              id: d["rootId"],
              remote_service_name: "tms",
              title: d["title"],
              original_title: d["title"],
              cast: Array(d["topCast"]).join(", "),
              categories: Array(d["genres"]).join(", "),
              world_premiere: date,
              premiere: date,
              length: runtime_to_minutes(d["runTime"]),
              cover_link: cover_link(d["preferredImage"]['uri'])
            }
          end
        end
      end

      class Cinema

        def extract_data data
          data.flat_map do |d|
            address = d["location"]["address"]
            {
              id: d["theatreId"],
              remote_service_name: 'tms',
              name: d["name"],
              street: address["street"],
              city_id: address["city"],
              phone: d["location"]["telephone"]
            }
          end
        end
      end
    end
  end
end