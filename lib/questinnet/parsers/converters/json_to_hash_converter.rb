require "json"
module Questinnet
  module Converter
    module SuperParser
      module JSONToHashConverter
        def self.convert data
          JSON.parse data
        end
      end
    end
  end
end