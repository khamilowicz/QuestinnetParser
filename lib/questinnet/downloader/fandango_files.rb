module Questinnet
  module Downloader
    module FandangoFiles
      def self.filename options={}
        options.values_at(:prefix, :format).join('.')
      end
    end
  end
end