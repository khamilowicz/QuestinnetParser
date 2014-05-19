class Finder

  def self.like options
    ->(object) do
      options.all? do |attr, value|
        object.send(attr) == value
      end
    end
  end
end