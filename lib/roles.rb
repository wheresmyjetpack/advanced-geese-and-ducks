module Obtainable
  attr_reader :garage

  def initialize(args)
    @garage = args[:garage]
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

  def name
    self.class.to_s
  end
end
