module Questinnet
  module Downloader
    class RSSDownloader
      attr_accessor :address, :path, :username, :password, :file
      def initialize options={}
        @address, @path, @username, @password, @file = options.values_at(:address, :path, :username, :password, :file)
      end

      def get
        Net::HTTP.get(URI([address, path, file].join('/')))
      end
    end
  end
end