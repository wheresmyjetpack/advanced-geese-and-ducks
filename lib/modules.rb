module Obtainable
  attr_writter :garage

  def garage
    @garage ||= ::Garage.new
  end

  def obtainable?(current_turn)
    !being_repaired?(current_turn)
  end

  def being_repaired?(current_turn)
    garage.repairing?(self, current_turn)
  end

  def repair_time
    0
  end
end
