# Questinnet

Can be used for retrieving and creating batches of objects

## Installation

Add this line to your application's Gemfile:

    gem 'questinnet'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install questinnet

## Usage

for pure questinnet objects

class ObjectParser

include Questinnet::Object

  conversion do |param|
    o = Object.new
    o.attr = params[:attr]
    o
  end
end

or

class ObjectParser

  include Questinnet::Object

  conversion(->{Object.new}) do |param, o|
    o.attr = params[:attr]
  end
end

Availabe Object names for Questinnet are: Movie, Show, Cinema, City

To configure credentials for server create file in intializers:

Questinnet::Downloader::Downloader.config do |config|
  config.username = your_username
  config.password = your_password
  config.address = ftp_server_address
end

Customization

class ObjectParser

  extend SuperParser

  converter converter_instance, source: source_name

  conversion do |params|
    o =Object.new
    o.attr = params[:attr]
    o
  end
end

converter instance must respond to extract_data(string) which returns hash of parameters. Now class can use method .parse to convert text data into objects.

using many sources at a time

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

FandangoTest.retrieve downloads downloads and converts objects from all sources

:source in download_config and converter are identifiers, so should be the same for one source

To configure new type converter:

Create file :type_donwloader.rb in downloader directory, require it in downloader.rb file
create new method get_:type in downloader.rb

create file :type_to_hash_converter.rb in parsers/converters, require it in super_parser.rb

for new source converter

add parser in parsers, require it in questinnet.rb

to configure parser:

look at tms/showtimes_spec for reference



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
