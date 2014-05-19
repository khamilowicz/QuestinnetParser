module Questinnet
  module Downloader
    class JSONDownloader

      attr_accessor :address, :path, :params

      def initialize options
        @address, @path, @params = options.values_at(:address, :path, :params)
      end

      def get
        uri = URI.join(address, path)
        uri.query = URI.encode_www_form(params)

        Net::HTTP.get(uri)
      end
    end
  end
end