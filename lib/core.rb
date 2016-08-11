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

  def intialize(args)
    @name = args[:name]
    @circle = args[:circle]
  end

  public
  def pass
    next_player
  end

  def tag
    player_at_position.selected
  end

  private
  def position
    if position.nil?
      @position = start_position
    else
      position
    end
  end

  def start_position
    circle.position(self) + 1
  end

  def next_player
    @position += 1
  end

  def player_at_position
    circle.players[position]
  end
end


class GameCircle
  attr_reader :players

  def initialize(args)
    @players = args[:players]
  end

  def remove(player)
    players.map! { |p| p.eq?(player) ? nil : p }    
    player
  end
  
  def position(player)
    players.index(player)
  end
end
