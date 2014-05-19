module Questinnet
  module Converter
    module SuperParser
      module RSSToHashConverter
        def self.convert data
          Nori.new(convert_tags_to: ->(tag){tag.downcase.tr(" -", "__").to_sym}).parse(data)
        end
      end
    end
  end
end