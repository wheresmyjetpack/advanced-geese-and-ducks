project_dir = File.dirname(File.expand_path("..", __FILE__))
require "#{project_dir}/lib/core"

class PlayerStub < Player
  def default_breed
    'viola'
  end
end

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

  def speed
    1
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


