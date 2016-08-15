class Duck
  attr_reader :name
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
    @base_speed = 1
  end

  def chase
    @base_speed + rand(-1..5)
  end
end


class Goose
  attr_reader :name
  attr_accessor :position

  def initialize(args)
    @name = args[:name]
    @base_speed = 2
  end

  def run
    @base_speed + rand(0..3)
  end
end
