class TestShow
  attr_accessor :cinema_id, :start_date, :end_date

  def initialize args={}
    @cinema_id, @start_date, @end_date = args.values_at(:cinema_id, :start_date, :end_date)
  end

  include Questinnet::Show

  download_config :update do |config|
    config.path = 'spec/api'
    config.file_prefix = 'seanse'
  end

  conversion do |params|
    new params
  end
end