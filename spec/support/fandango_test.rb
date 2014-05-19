Questinnet::Downloader::Downloader.config do |config|
  config.source = :fandango
  config.type = :rss
  config.method = :rss
  config.address = 'http://www.fandango.com'
end

# Questinnet::Downloader::Downloader.config do |config|
#   config.source = :questinnet
#   config.type = :xml
#   config.method = :ftp
#   config.address = 'localhost:21212'
#   config.username = "Anonymous"
#   config.password = ''
# end

class FanMovie
  attr_accessor :title
end

class FandangoTest

  include Questinnet::Film

  converter Questinnet::Converter::Fandango.new, source: :fandango

  conversion(->{FanMovie.new}) do |params, object|
    object.title = params[:title]
  end

  download_config :update do |c|
    c.source = :questinnet
    c.path = 'spec/api'
  end

  download_config do |c|
    c.source = :fandango
    c.type = :rss
    c.path = 'rss'
    c.file_prefix = 'newmovies'
  end
end