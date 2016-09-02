require_relative 'roles'

class Chaser
  attr_reader :name, :breed, :points
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
    @breed = args[:breed] || default_breed
    @points = 0
    @obtainable = nil
    post_initialize(args)
  end

  def post_initialize(args)
    nil
  end

  public
  def name
    "#{@name} the #{breed}"
  end

  def distracted?
    false
  end

  def catches?(runner)
    distracted? ? distracted : determine_speed >= runner.run
  end

  def score
    @points += 1
  end

  def obtain(obtainable)
    @obtainable = obtainable
  end

  private
  def determine_speed
    base_speed
  end

  def base_speed
    1
  end

  def default_breed
    raise NotImplementedError
  end

  def distracted
    raise NotImplementedError
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

  def default_breed
    ["mallard", "hook bill", "Welsh harlequin"].sample
  end
end


class Dog < Chaser
  def post_initialize(args)
    @toys = 0
  end

  public
  def distracted?
    [true, false, false].sample
  end

  def distracted
    if found_toy?
      add_toy
      unless max_toys?
        puts "#{name}'s attention was drawn by something squeaky... found a chew toy!"
      else
        puts "#{name} found a third chew toy... they seem excited for the next round."
      end
    else
      puts "WOOF WOOF! #{name} chased after a squirrel instead!"
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
  def post_initialize(args)
    @catnip = false
  end

  public
  def distracted?
    unless @catnip
      [true, false].sample
    else
      false
    end
  end

  def distracted
    if found_catnip?
      add_catnip
      puts "#{self.name} found some catnip, they seem really excited for the next round!"
    else
      puts "MEOW! #{self.name} got distracted by a ball of yarn!"
    end
  end

  private
  def determine_speed
    (base_speed * rand(1..3)) + 1 + bonus_speed
  end

  def base_speed
    3
  end
  
  def bonus_speed
    bonus = 0
    bonus += obtainable_speed
    bonus += use_catnip if @catnip
    bonus
  end

  def found_catnip?
    [true, false, false].sample
  end

  def add_catnip
    @catnip = true
  end

  def use_catnip
    @catnip = false
    1 + rand(1..3)
  end

  def obtainable_speed
    @obtainable ? @obtainable.speed : 0
  end

  def default_breed
    ["Siamese", "American shorthair", "tabby"].sample
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


class Bicycle
  include Obtainable

  def speed
    rand(1..6)
  end

  def repair_time
    3
  end
end


class Skateboard
  include Obtainable

  def speed
    rand(2..4)
  end

  def repair_time
    2
  end
end


class Rollerblades
  include Obtainable

  def speed
    2
  end

  def repair_time
    1
  end
end


class Garage
  attr_reader :repair_shop

  def initialize
    @repair_shop = {}
  end

  public
  def repair(obtainable, turn)
    repair_shop[obtainable.to_s] = turn
  end

  def repairing?(obtainable, current_turn)
    (started_repairing(obtainable) + obtainable.repair_time) > current_turn
  end

  private
  def started_repairing(obtainable)
    repair_shop[obtainable.to_s] || 0 - obtainable.repair_time
  end
end
