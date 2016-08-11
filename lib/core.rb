class Player
end


class Duck < Player
  attr_reader :name

  def initalize(args)
    @name = args[:name]
  end

end


class Goose < Player
  attr_reader :name, :circle, :position

  def initialize(args)
    @name = args[:name]
    @circle = args[:circle]
    @base_speed = 1
  end

  public
  def pass
    next_player
  end

  def tag
    player_at_position.selected
    run
  end

  def position
    @position ||= start_position
  end

  private
  def start_position
    start = circle.position_of(self)
    leave_circle
    start
  end

  def leave_circle
    players_in_circle.delete(self)
  end

  def run
    @base_speed += rand(0..2)
  end

  def next_player
    unless position + 1 > players_in_circle.size - 1
      @position += 1
    else
      @position = 0
    end
  end

  def player_at_position
    players_in_circle[position]
  end

  def players_in_circle
    circle.players
  end
end


class GameCircle
  attr_accessor :players

  def vacate(player)
    players.map! { |p| p.eq?(player) ? nil : p }    
    player
  end
  
  def position_of(player)
    players.index(player)
  end
end
