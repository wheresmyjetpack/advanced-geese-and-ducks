class Chaser
  attr_reader :name
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
  end

  public
  def distracted?
    false
  end

  private
  def base_speed
    1
  end
end


class Duck < Chaser
  public
  def chase
    base_speed + rand(-1..5)
  end

  private
  def base_speed
    2
  end
end


class Dog < Chaser
  public
  def chase
    base_speed + rand(0..2)
  end

  def distracted?
    [true, false, false].sample
  end

  def distracted
    "WOOF WOOF! #{self.name} chased after a stray cat instead!"
  end

  private
  def base_speed
    3
  end
end


class Cat < Chaser
  public
  def chase
    base_speed * rand(1..3)
  end

  def distracted?
    [true, false].sample
  end

  def distracted
    "MEOW! #{self.name} got distracted by a ball of yarn!"
  end

  private
  def base_speed
    3
  end
end


class Goose
  attr_reader :name
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
  end

  public
  def run
    base_speed + rand(1..3)
  end

  private
  def base_speed
    3
  end
end
