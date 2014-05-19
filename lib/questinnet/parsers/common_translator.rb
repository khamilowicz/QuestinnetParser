module Questinnet
  module Converter
    module CommonTranslator

      attr_reader :raw_hash
      attr_writer :dictionary_path

      def extract_data raw_hash
        @raw_hash = raw_hash
        items.map{|d| translate(d).merge(additional_params) }
      end

      def additional_params
        {remote_service_name: 'questinnet'}
      end

      def dictionary_path
        @dictionary_path || raise("converter must define path to dictionary (dictionary: path)")
      end

      def translate questinnet_object
        questinnet_object.each_with_object({}) do |(key, value), item|
          if translated_key = dictionary(key)
            if value.is_a?(Hash)
              value = translate value
            elsif value.is_a?(Array)
              value = value.map{|v| translate v}
            end
            item[translated_key.to_sym] = value
          end
        end
      end

      def dictionary key
        store.fetch(key, nil)
      end

      def store
        @_store ||= ensure_format do
          YAML.load_file dictionary_path
        end
      end

      def ensure_format &block
        store = yield
        unless store.has_key? 'path_to_content'
          raise 'dictionary has to define "path_to_content"'
        else
          store
        end
      end

      def items
        @_items ||= hash_path.inject(raw_hash) do |value, key|
          value.fetch(key, {})
        end
      end

      def hash_path
        @_hash_path ||= store['path_to_content'].split(',')
      end
    end
  end
end