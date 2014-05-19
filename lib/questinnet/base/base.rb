require "yaml"
DOWNLOADER_CONFIG ||= YAML.load_file(File.join(File.dirname(__FILE__), 'downloader_config.yml'))

module Questinnet

  module Base
    def self.included receiver
      item_klass = name.split("::").last
      namespace = Questinnet

      names = ["Converter", item_klass]
      converter = names.reduce(namespace){|mod, name| mod.const_get(name)}
      receiver.send :include, converter
      receiver.send :include, Downloader


      unless Downloader::Downloader.configured?
        base =
        DOWNLOADER_CONFIG['credentials'] ||
        raise("Server credentials not set. \
              Define username, password and address \
              in 'download_config.yml' under 'credentials' tag")
        Downloader::Downloader.config do |config|
          config.username = base['username']
          config.password = base['password']
          config.address  = base['address']
        end
      end

      down_config = DOWNLOADER_CONFIG[item_klass.downcase] ||
      raise("Downloader not set. Define it in lib/base/download_config.yml")
      receiver.download_config do |config|
        config.path        = down_config['path']
        config.file_prefix = down_config['file_prefix']
      end
    end
  end

  def self.available_types
    Converter.available_converters.map{|converter| converter.name.split("::").last}
  end

  available_types.each do |type|
    const_set type, Base.dup
  end
end