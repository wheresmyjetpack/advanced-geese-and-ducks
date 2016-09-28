class RepairerStub
  def repair(obtainable)
    nil
  end

  def repairing?(obtainable)
    true
  end
end


class RunnerStub
  def run
    1
  end
end


class ObtainableStub
  def name
    'name'
  end

  def owned_by(name)
    nil
  end

  def obtainable?
    true
  end

  def fixed
    []
  end

  def repair_time
    1
  end
end


