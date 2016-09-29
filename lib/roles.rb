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
    false
  end
end


module Obtainable
  attr_reader :repairer

  public
  def name
    self.class.to_s.downcase
  end

  def repairer
    @repairer ||= ::KnowsRound::Garage.new
  end

  def obtainable?
    !being_repaired?
  end

  def owned_by(name)
    @owner = name
  end

  def speed
    nil
  end

  private
  def repair
    local_notify_repairs
    repairer.repair(self)
  end

  def being_repaired?
    repairer.repairing?(self)
  end

  def local_notify_repairs
    nil
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

  private
  def broken_parts?
    parts.broken_parts?
  end

  def num_broken_parts
    parts.num_broken_parts
  end
end
