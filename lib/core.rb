class Chaser
  attr_reader :name
  attr_accessor :position
end


class Duck < Chaser
  def initialize(args)
    @name = args[:name]
    @base_speed = 3
  end

  def chase
    @base_speed + rand(-1..5)
  end
end


class Dog < Chaser
  def initialize(args)
    @name = args[:name]
    @base_speed = 4
  end

  def chase
    @base_speed + rand(0..2)
  end

  def distracted?
    [true, false, false].sample
  end

  def distracted
    "WOOF WOOF! #{self.name} chased after a stray cat instead!"
  end
end


class Cat < Chaser
  def initialize(args)
    @name = args[:name]
    @base_speed = 3
  end
  
  def chase
    @base_speed * rand(1..3)
  end

  def distracted?
    [true, false].sample
  end
end


class Goose
  attr_reader :name
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
    @base_speed = 3
  end

  def run
    @base_speed + rand(1..3)
  end
end
