require_relative './super_parser'
require_relative './base'

module Questinnet
  module Converter
    def self.translations
      Dir.glob(File.join(File.dirname(__FILE__), 'translations', '*'))
    end

    def self.available_converters
      @_available_converters ||= translations.map{|t| const_get(klass_name t)}
    end

    def self.klass_name translation
      File.basename(translation, '.yml').capitalize
    end

    translations.each do |translation|

      klass = klass_name translation

      const_set(klass, Module.new)

      const_get(klass).define_singleton_method :included do |receiver|
        receiver.extend SuperParser
        receiver.converter Base.new(dictionary: translation)
      end
    end
  end
end