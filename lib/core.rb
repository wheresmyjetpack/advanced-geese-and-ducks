require 'forwardable'
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

  def lose_point
    @points -= 1
  end

  def obtain(item, current_round)
    if item.obtainable?(current_round)
      @obtainable = item
    else
      puts "That item is unavailable right now!"
      puts
    end
  end

  def repair_if_broken(current_round)
    if broken_item?
      puts "#{name}'s #{@obtainable.name} broke! Sending it to the garage for repairs"
      repair_item(current_round)
      @obtainable = nil
    end
  end

  private
  def determine_speed
    base_speed + bonus_speed
  end

  def base_speed
    1
  end

  def bonus_speed
    bonus = 0
    bonus += obtainable_speed
    bonus
  end

  def obtainable_speed
    @obtainable ? @obtainable.speed : 0
  end

  def broken_item?
    # check if item is broken, always return false if no item for chaser
    if @obtainable
      @obtainable.broken_parts?
    else
      false
    end
  end

  def repair_item(current_round)
    @obtainable.repair(current_round)
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
    base_speed + rand(-1..5) + bonus_speed
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
    else
      puts "WOOF WOOF! #{name} chased after a squirrel instead!"
    end
  end

  private
  def add_toy
    @toys += 1
    unless max_toys?
      puts "#{name}'s attention was drawn by something squeaky... found a chew toy!"
    else
      puts "#{name} found a third chew toy... they seem excited for the next round."
    end
  end

  def base_speed
    3
  end

  def max_toys?
    @toys >= 3
  end

  def determine_speed
    base_speed + rand(0..2) + bonus_speed
  end

  def bonus_speed
    bonus = 0
    if max_toys?
      bonus += rand(1..2)
      @toys = 0
    end
    bonus += obtainable_speed
    bonus
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
    @catnip ? false : [true, false].sample
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
  include BreakableParts
  attr_reader :parts

  def initialize(args)
    @garage = args[:garage]
    @parts = args[:parts]
    @broken_parts = Array.new
  end

  def speed
    rand(1..2) + parts_quality
  end

  def repair_time
    5 * num_broken_parts
  end

  private
  def parts_quality
    parts.quality
  end
end


class Skateboard
  include Obtainable
  include BreakableParts
  attr_reader :parts

  def initialize(args)
    @garage = args[:garage]
    @parts = args[:parts]
    @broken_parts = Array.new
  end

  def speed
    1 + parts_quality
  end

  def repair_time
    4 * num_broken_parts
  end

  private
  def parts_quality
    parts.quality
  end
end


class Rollerblades
  include Obtainable
  include BreakableParts
  attr_reader :parts

  def initialize(args)
    @garage = args[:garage]
    @parts = args[:parts]
    @broken_parts = Array.new
  end

  def speed
    parts_quality
  end

  def repair_time
    3 * num_broken_parts
  end

  private
  def parts_quality
    parts.quality
  end
end


class Garage
  attr_reader :repair_shop

  def initialize
    @repair_shop = {}
  end

  public
  def repair(obtainable, round)
    # set the value of the obtainable in the repair_shop to the round repairs started
    repair_shop[obtainable.to_s] = round
    puts "Repairing the #{obtainable.name}, should be ready again on round #{obtainable.repair_time + round + 1}"
  end

  def repairing?(obtainable, current_round)
    still_repairing = (started_repairing(obtainable) + obtainable.repair_time) >= current_round
    unless still_repairing
      obtainable.fixed
    end
    still_repairing
  end

  private
  def started_repairing(obtainable)
    repair_shop[obtainable.to_s] || 0 - obtainable.repair_time
  end
end


class Parts
  attr_reader :broken_parts
  extend Forwardable
  def_delegators :@parts, :each, :size, :inject
  include Enumerable

  def initialize(parts)
    @parts = parts
    @broken_parts = Array.new
  end

  public
  def quality
    inject(0) { |sum, part| sum += enhancement_of(part) } 
  end

  def fix
    broken_parts.clear
  end

  def broken_parts?
    each do |part|
      broken_parts << part if broken?(part)
    end
    broken_parts.empty? ? false : true
  end

  private
  def enhancement_of(part)
    part.speed_boost
  end

  def broken?(part)
    part.broken?
  end
end


class Part
  attr_reader :name, :description, :speed_boost

  def initialize(args)
    @name = args[:name]
    @description = args[:description]
    @speed_boost = args[:speed_boost]
    @break_chance = args[:break_chance]
  end
  
  public
  def broken?
    breaks?
  end

  private
  def breaks?
    broken = rand() <= @break_chance
    if broken
      puts "*** The #{description} #{name} broke ***"
      return broken
    end
    broken
  end
end


module PartsFactory
  def self.build(config, parts_class=Parts, part_class=Part)
    parts_class.new(
      config.collect do |part_config|
        part_class.new(
          name: part_config[0],
          description: part_config[1],
          speed_boost: part_config[2],
          break_chance: part_config.fetch(3, 0.0)
        )
      end
    )
  end
end

