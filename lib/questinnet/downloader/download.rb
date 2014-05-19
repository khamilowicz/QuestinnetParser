class Struct
  def to_h
    self.members.each_with_object({}) do |at, sum|
      sum[at] = self.send at
    end
  end
end
module Questinnet
  module Downloader

    module ClassMethods

      Config = Struct.new(:path, :file_prefix, :source, :type, :params)

      def downloaders
        @downloaders ||= []
      end

      def downloader
        if downloaders.count > 1
          raise("Many downloaders: #{downloaders.map(&:source).join(', ')}")
        elsif downloaders.count == 1
          downloaders.first
        else
          raise("No downloaders configured")
        end
      end

      def download_config *options
        config = Config.new
        yield config
        case
        when options.include?(:update)
          update_downloader config
        else
          set_downloader config
        end
      end

      def update_downloader config
        downloader.update(config.to_h)
      end

      def set_downloader config
        downloaders << Downloader.new( config.to_h)
      end

      def download options={}
        if block_given?
          downloaders.reduce([]) do |output, downloader|
            output += yield downloader
          end
        else
         downloaders.each_with_object({}) do |downloader, reduced|
          reduced[downloader.source] = {} unless reduced[downloader.source]
          reduced[downloader.source][downloader.type] = [] unless reduced[downloader.source][downloader.type]
          reduced[downloader.source][downloader.type] << downloader.download
        end
      end
    end
  end

  module InstanceMethods

    def initialize *args
      super
      self.class.downloader
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
end