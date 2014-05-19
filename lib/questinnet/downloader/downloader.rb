# encoding: UTF-8
require "net/ftp"
require_relative './questinnet_files'
require_relative './fandango_files'
require_relative './download'
require_relative './retriever'
require_relative './ftp_downloader'
require_relative './rss_downloader'
require_relative './json_downloader'

module Questinnet

  module Downloader
    class Downloader
      attr_reader :username, :password, :file_prefix, :address, :path, :source, :type, :params
      Config = Struct.new(:username, :password, :file_prefix, :address, :source, :method, :type, :params)
      @@config = {}

      def self.config
        if block_given?
          config = Config.new
          yield config
          update_configs config
        else
          @@config
        end
      end

      def self.configured?
        config = @@config.values.first
        !(config.username.nil? || config.password.nil? || config.address.nil?)
      rescue
        false
      end

      def update options
        @source = options[:source] || @source
        @type = options[:type] || @type
        @file_prefix = options[:file_prefix] || @file_prefix
        @path = options[:path] || @path
        @params = options[:params] || @params
      end

      def initialize options={}
        @@config.empty? && raise("Questinnet::Downloader not configured")
        @source = options[:source] || default_source
        @type = options[:type] || @@config[source].type || default_type
        @file_prefix = options[:file_prefix] || @@config[source].file_prefix
        @path = options.fetch(:path, '/')
        @params = options[:params]
        errors_raiser
      end

      def errors_raiser
        case method
        when :ftp
          username || raise("Username not set")
          password || raise("Password not set")
          # file_prefix || raise("File prefix not provided or set")
        end
        address || raise("Address not set")
      end

      def params
        @params.call
      end

      def password
        @@config[source].password
      end

      def address
        @@config[source].address
      end

      def username
        @@config[source].username
      end

      def method
        @@config[source].method || :ftp
      end

      def download
        get(filename)
      end

      def get_ftp file
        FTPDownloader.new(file: file, address: address, password: password, username: username, path: path).get
      end

      def get_rss file
        RSSDownloader.new(file: file, address: address, path: path).get
      end

      def get_json file
        file_path = [path, file].join("/")
        repeater = params.delete(:repeat_on)
        repeat_on(repeater, params) do |par|
          parameters = {api_key: password}.merge(par)
          JSONDownloader.new(address: address, path: file_path, params: parameters).get
        end
      end

      def repeat_on repeater, params
        if repeater.nil?
          yield params
        else
          repeater = Array(repeater)
          Array(params[repeater.first]).map.with_index do |_, index|
            yield params.merge( repeater.each_with_object({}) do |r, hash|
                                  hash[r] = params[r][index]
                                end )
          end.join.gsub(/\]\[/, ",")
        end
      end

      def get file
        case method
        when :ftp then get_ftp file
        when :rss then get_rss file
        when :json then get_json file
        else
          raise("Unknown download method")
        end
      end

      def filename options={}
        case source
        when :questinnet
          options[:prefix] ||= file_prefix
          QuestinnetFiles.filename options
        when :fandango
          FandangoFiles.filename prefix: file_prefix, format: type
        when :tms
          file_prefix
        else
          raise("Filename creator not provided")
        end
      end

      def self.default_source
        :questinnet
      end

      def self.default_type
        :xml
      end

      def default_type
        self.class.default_type
      end

      def default_source
        self.class.default_source
      end

      private

      def self.update_configs config
        @@config[config.source || default_source] = config
      end
    end
  end
end