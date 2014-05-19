module Questinnet
  module Downloader
    module QuestinnetFiles
      def self.filename options={}
        prefix = options.fetch(:prefix)
        day = options[:day]
        day ||= if Date.today.thursday? || Date.today.friday? || Date.today.wednesday?
          Date.today.next_day(7)
        else
          Date.today
        end
        ext = "." + (options[:format] || 'xml').to_s

        prefix + formatted_movie_week(day) + ext
      end

      def self.time_format
        "%Y%m%d"
      end

      def self.formatted_movie_week day
        beginning_of_movie_week(day).strftime(time_format)
      end

      def self.beginning_of_movie_week date
        date.prev_day(date.cwday + 7).next_day(5)
      end
    end
  end
end