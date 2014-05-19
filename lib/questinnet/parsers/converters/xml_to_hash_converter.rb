module Questinnet
  module Converter
    module SuperParser
      module XMLToHashConverter
        def self.convert data
          Nori.new.parse(data)
        end
      end
    end
  end
end