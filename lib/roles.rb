module Obtainable
  attr_reader :repairer

  def repairer
    @repairer ||= ::Garage.new
  end

  def obtainable?(current_round)
    !being_repaired?(current_round)
  end

  def being_repaired?(current_round)
    repairer.repairing?(self, current_round)
  end

  def repair_time
    0
  end

  def repair(current_round)
    repairer.repair(self, current_round)
  end

  def name
    self.class.to_s
  end
end


module BreakableParts
  public
  def parts
    @parts ||= ::Parts.new
  end

  def broken_parts
    parts.broken_parts
  end

  def repair_time
    num_broken_parts
  end

  def fixed
    parts.fix
  end

  def broken_parts?
    parts.broken_parts?
  end

  private
  def num_broken_parts
    broken_parts.size
  end
end
