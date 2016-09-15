require 'forwardable'
require_relative 'roles'

class Player
  attr_reader :breed
  attr_accessor :position, :points

  def initialize(args)
    @name = args[:name]
    @points = 0
    post_initialize(args)
  end

  public
  def name
    "#{@name} the #{breed}"
  end

  def score
    @points += 1
  end

  def lose_point
    @points -= 1
  end

  def obtain(item)
    if item.obtainable?
      @obtainable = item
    else
      puts "That item is unavailable right now!"
      puts
    end
  end

  private
  def obtainable_speed
    unless @obtainable.nil? || !rideable?(@obtainable)
      @obtainable.speed
    else
      0
    end
  end

  def rideable?(rideable)
    rideable.obtainable?
  end

  def default_breed
    raise NotImplementedError
  end
end


class Duck < Player
  include ::Chaser
  attr_reader :base_speed

  def post_initialize(args)
    @breed = args[:breed] || default_breed
    @base_speed = 2
    @obtainable = nil
  end

  private
  def determine_speed
    base_speed + rand(-1..5) + bonus_speed
  end

  def bonus_speed
    obtainable_speed
  end

  def default_breed
    ["mallard", "hook bill", "Welsh harlequin"].sample
  end
end


class Dog < Player
  include ::Chaser
  attr_reader :base_speed
  attr_accessor :toys

  def post_initialize(args)
    @breed = args[:breed] || default_breed
    @base_speed = 3
    @toys = 0
    @obtainable = nil
  end

  private
  def distracted
    if found_toy?
      add_toy
    else
      puts "WOOF WOOF! #{name} chased after a squirrel instead!"
    end
  end

  def add_toy
    @toys += 1
    unless max_toys?
      puts "#{name}'s attention was drawn by something squeaky... found a chew toy!"
    else
      puts "#{name} found a third chew toy... they seem excited for the next round."
    end
  end

  def distracted?
    [true, false, false].sample
  end

  def max_toys?
    toys >= 3
  end

  def determine_speed
    base_speed + rand(0..2) + bonus_speed
  end

  def bonus_speed
    max_toys? ? (obtainable_speed + toy_bonus) : obtainable_speed
  end

  def toy_bonus
    toys = 0
    rand(1..2)
  end

  def found_toy?
    [true, true, false, false, false].sample
  end

  def default_breed
    %w{corgi greyhound pitbull}.sample
  end
end


class Cat < Player
  include ::Chaser
  attr_reader :base_speed

  def post_initialize(args)
    @breed = args[:breed] || default_breed
    @base_speed = 3
    @obtainable = nil
    @catnip = false
  end

  private
  def determine_speed
    (base_speed * rand(1..3)) + 1 + bonus_speed
  end

  def bonus_speed
    @catnip ? (obtainable_speed + use_catnip) : obtainable_speed
  end

  def distracted?
    @catnip ? false : [true, false].sample
  end

  def distracted
    if found_catnip?
      @catnip = true
      puts "#{self.name} found some catnip, they seem really excited for the next round!"
    else
      puts "MEOW! #{self.name} got distracted by a ball of yarn!"
    end
  end

  def found_catnip?
    [true, false, false].sample
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
  attr_reader :name, :base_speed
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
    @base_speed = 3
  end

  public
  def run
    base_speed + rand(2..5)
  end
end


class Bicycle
  include ::BreakableParts
  attr_reader :parts

  def initialize(args)
    @repairer = args[:garage]
    @parts = args[:parts]
  end

  public
  def speed
    if broken_parts?
      0
    else
      rand(1..2) + parts_quality
    end
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
  include ::BreakableParts
  attr_reader :parts

  def initialize(args)
    @repairer = args[:garage]
    @parts = args[:parts]
  end

  public
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
  include ::BreakableParts
  attr_reader :parts

  def initialize(args)
    @repairer = args[:garage]
    @parts = args[:parts]
  end

  public
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
    broken = rand() <= @break_chance
    if broken
      needs_repairs
    else
      false
    end
  end

  private
  def needs_repairs
    puts "*** The #{description} #{name} broke ***"
    true  # return true to indicate that the part is broken
  end
end


module KnowsRound
  attr_accessor :current_round
  @current_round = 0

  class Garage
    attr_reader :repair_shop

    def initialize
      @repair_shop = {}
    end

    public
    def repair(obtainable)
      # set the value of the obtainable in the repair_shop to the round repairs started
      puts "Repairing the #{obtainable.name}, should be ready again on round #{obtainable.repair_time + KnowsRound.current_round + 1}"
      repair_shop[obtainable.name] = KnowsRound.current_round
    end

    def repairing?(obtainable)
      still_repairing = (started_repairing(obtainable) + obtainable.repair_time) >= KnowsRound.current_round
      unless still_repairing
        obtainable.fixed
      end
      still_repairing
    end

    private
    def started_repairing(obtainable)
      repair_shop[name_of(obtainable)] || 0 - obtainable.repair_time
    end

    def name_of(obtainable)
      obtainable.name
    end
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
