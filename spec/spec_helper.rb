require "tempfile"
require "pry"

Dir.glob("./lib/questinnet.rb") do |file|
  require file
end

Dir.glob("./spec/support/**/*.rb") do |file|
  require file
end