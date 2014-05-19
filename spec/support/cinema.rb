class Cinema

  attr_accessor :name, :id, :street

  def self.from_hash hash
    hash.each_with_object(new) do |(key, value), film|
      film.send key.to_s + '=', value
    end
  end

  def id= num
    @id = num.to_i
  end
end