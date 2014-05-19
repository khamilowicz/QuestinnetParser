require "nori"
require_relative './converters/xml_to_hash_converter'
require_relative './converters/rss_to_hash_converter'
require_relative './converters/json_to_hash_converter'

module Questinnet
  module Converter
    module SuperParser


      def parse data, options={}
        @data = data
        @translator_id = options.fetch(:translator, :questinnet)

        choose_format

        parsed_data.map do |object|
          if @object_method
            conversion_with_proc object
          else
            conversion_method.call object
          end
        end
      end

      def conversion object_method=nil, &block
        @object_method = object_method
        @conversion = block
      end

      def converter tr, options={}
        @translators ||= {}
        if tr.respond_to?(:extract_data)
          @translators[options.fetch(:source, :questinnet)] = tr
        else
          raise("converter must respond to #extract_data")
        end
      end

      private

      attr_reader :data, :key, :translator_id

      def conversion_with_proc object
        new_ob = @object_method.call
        conversion_method.call object, new_ob
        new_ob
      end

      def parsed_data
        extracted_data = translator.extract_data parser_name.convert(data[key])
        extracted_data.is_a?(Array) ? extracted_data : []
      end

      def parser_name
        SuperParser.const_get(key.to_s.upcase + 'ToHashConverter')
      end

      def formats
        [:xml, :rss, :json]
      end

      def choose_format
        @key = (data.keys & formats).first || raise("Unknown format. Should be one of: #{formats.join(", ")}")
      end

      def conversion_method
        @conversion || raise("#conversion not defined")
      end

      def translator
        @translators[translator_id]
      end

      def translators
        @translators || raise("#converter not defined. Define it")
      end
    end
  end
end