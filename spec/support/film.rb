require "ostruct"

class Film
  attr_accessor :title, :id, :original_title, :production_year, :country,
  :length, :minimum_age, :director, :premiere, :category, :cast

  def id= num
    @id = num.to_i
  end
end