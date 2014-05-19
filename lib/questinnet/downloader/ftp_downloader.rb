module Questinnet
  module Downloader
    class FTPDownloader
      attr_accessor :address, :path, :username, :password, :file
      def initialize options={}
        @address, @path, @username, @password, @file = options.values_at(:address, :path, :username, :password, :file)
      end

      def get
        base, port = address.split(':')
        if port
          ftp = Net::FTP.new
          ftp.connect(base, port)
        else
          ftp = Net::FTP.new address
        end
        ftp.passive = true
        ftp.login username, password
        ftp.chdir path
        ftp.gettextfile(file,nil)
      ensure
        ftp.close
      end
    end

  end
end