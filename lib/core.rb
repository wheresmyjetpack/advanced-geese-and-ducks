class Chaser
  attr_reader :name, :breed
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
    @breed = args[:breed] || default_breed
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
    determine_speed >= runner.run
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
      "#{self.name} found some catnip, they seem really excited for the next round!"
    else
      "MEOW! #{self.name} got distracted by a ball of yarn!"
    end
  end

  private
  def determine_speed
    unless @catnip
      (base_speed * rand(1..3)) + 1
    else
      use_catnip
    end
  end

  def base_speed
    3
  end

  def found_catnip?
    [true, false, false].sample
  end

  def add_catnip
    @catnip = true
  end

  def use_catnip
    @catnip = false
    (( base_speed + 1 ) * rand(1..3)) + 1
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
  def speed
    3
  end
end


class Skateboard
  def speed
    2
  end
end


class Rollerblades
  def speed
    1
  end
end


class VehicleShop
  def obtainable?(target, start, current_turn)
    if target.class == Bicycle
      repair_time = 3
    elsif target.class == Skateboard
      repair_time = 2
    elsif target.class == Rollerblades
      repair_time = 1
    end
    !being_repaired?(target, start, current_turn, repair_time)
  end

  def being_repaired?(target, start, current_turn, repair_time)
    if start + repair_time < current_turn
      true
    end
  end
end
