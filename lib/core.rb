class Chaser
  attr_reader :name
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
    post_initialize(args)
  end

  def post_initialize(args)
    nil
  end

  public
  def distracted?
    false
  end

  def catches?(runner)
    determine_speed >= runner.run
  end

  private
  def determine_speed
    raise NotImplementedError
  end

  def base_speed
    1
  end
end


class Duck < Chaser
  private
  def determine_speed
    base_speed + rand(-1..5)
  end

  def base_speed
    2
  end
end


class Dog < Chaser
  attr_reader :breed

  def post_initialize(args)
    @breed = args[:breed] || default_breed
    @toys = 0
  end

  public
  def name
    "#{@name} the #{breed}"
  end

  def distracted?
    [true, false, false].sample
  end

  def distracted
    if found_toy?
      add_toy
      unless max_toys?
        "#{name}'s attention was drawn by something squeaky... found a chew toy!"
      else
        "#{name} found a third chew toy... they seem excited for the next round."
      end
    else
      "WOOF WOOF! #{name} chased after a squirrel instead!"
    end
  end

  private
  def add_toy
    @toys += 1
  end

  def base_speed
    3
  end

  def max_toys?
    @toys >= 3
  end

  def determine_speed
    unless max_toys?
      base_speed + rand(0..2)
    else
      @toys = 0
      base_speed + rand(1..3)
    end
  end

  def found_toy?
    [true, true, false, false, false].sample
  end

  def default_breed
    %w{corgi greyhound pitbull}.sample
  end
end


class Cat < Chaser
  public
  def distracted?
    [true, false].sample
  end

  def distracted
    "MEOW! #{self.name} got distracted by a ball of yarn!"
  end

  private
  def determine_speed
    (base_speed * rand(1..3)) + 1
  end

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
