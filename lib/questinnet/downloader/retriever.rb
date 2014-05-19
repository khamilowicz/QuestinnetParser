module Questinnet
  module Downloader

    def included receiver
      receiver.extend ClassMethods
    end

    module ClassMethods
      def retrieve
        download do |d|
          parse( {d.type => d.download}, translator: d.source)
        end
      end
    end
  end
end