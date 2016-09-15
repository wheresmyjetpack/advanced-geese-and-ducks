module Chaser
  public
  def catches?(runner)
    distracted? ? distracted : determine_speed >= runner.run
  end

  private
  # implementers can overriide any of the following
  def distracted?
    false
  end

  def determine_speed
    base_speed + bonus_speed
  end

  def base_speed
    1
  end

  def bonus_speed
    0
  end

  def distracted
    raise NotImplementedError
  end
end


module Obtainable
  attr_reader :repairer

  public
  def name
    self.class.to_s
  end

  def repairer
    @repairer ||= ::KnowsRound::Garage.new
  end

  def obtainable?
    !being_repaired?
  end

  def repair
    repairer.repair(self)
  end

  private
  def being_repaired?
    repairer.repairing?(self)
  end
end


module BreakableParts
  include ::Obtainable
  public
  def parts
    @parts ||= ::Parts.new
  end

  def repair_time
    num_broken_parts
  end

  def fixed
    parts.fix
  end

  def broken_parts?
    broken = parts.broken_parts?
    if broken
      repair
    end
    broken
  end

  private
  def broken_parts
    parts.broken_parts
  end

  def num_broken_parts
    broken_parts.size
  end
end
