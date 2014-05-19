class Show
  attr_accessor :cinema_id, :start_date, :end_date, :hours, :movies

  def self.from_hash hash
    hash.each_with_object(new) do |(key, value), film|
      film.send key.to_s + '=', value
    end
  end

  def cinema_id= num
    @cinema_id = num.to_i
  end
end