require_relative './common_translator'

module Questinnet
  module Converter
    class Fandango
      def extract_data data
        [:rss, :channel, :item].reduce(data){|reduced, key| reduced[key]}
      end
    end
  end
end