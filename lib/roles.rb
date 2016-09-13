module Obtainable
  attr_reader :garage

  def initialize(args)
    @garage = args[:garage]
    post_initialize(args)
  end

  def post_initialize
    nil
  end

  def obtainable?(current_round)
    !being_repaired?(current_round)
  end

  def being_repaired?(current_round)
    garage.repairing?(self, current_round)
  end

  def repair_time
    0
  end

  def repair(current_round)
    garage.repair(self, current_round)
  end

  def name
    self.class.to_s
  end
end


module Breakable
  def broken_parts
    @broken_parts ||= Array.new
  end

  def parts
    # needs to be implemented in the class inheriting Repairable's behavior
    raise NotImplementedError
  end

  def repair_time
    5 * @broken.size
  end

  def fixed
    broken_parts.clear
  end

  def broken_parts?
    parts.each do |part|
      broken_parts << part if broken?(part)
    end
    broken_parts.empty? ? false : true
  end

  def num_broken_parts
    broken_parts.size
  end

  private
  def broken?(part)
    part.broken?
  end
end
