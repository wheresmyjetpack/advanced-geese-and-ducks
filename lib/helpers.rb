def runner_factory(player, type)
  type.new(name: player.name)
end

def player_factory(name, type)
  type.new(name: name)
end

def starting_position(player, circle)
  index = circle.find_index(player)
  raise IndexError if index.to_i >= circle.length - 1
  rescue StandardError
    index = circle.length - 2
  else
    index
end
