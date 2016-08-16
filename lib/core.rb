class Player
  attr_reader :name
  attr_accessor :position
end


class Duck < Player
  def initialize(args)
    @name = args[:name]
    @base_speed = 3
  end

  def chase
    @base_speed + rand(-1..5)
  end
end


class Goose < Player
  def initialize(args)
    @name = args[:name]
    @base_speed = 3
  end

  def run
    @base_speed + rand(1..3)
  end
end


class Dog < Player
  def initialize(args)
    @name = args[:name]
    @base_speed = 4
  end

  def chase
    @base_speed + rand(0..2)
  end

  def distracted?
    [true, false].sample
  end

  def distracted
    "WOOF WOOF! #{self.name} chased after a stray cat instead!"
  end
end
