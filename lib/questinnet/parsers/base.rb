require_relative './common_translator'

module Questinnet
  module Converter
    class Base
      include CommonTranslator

      def initialize options
        self.dictionary_path = options[:dictionary]
      end
    end
  end
end