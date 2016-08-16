#!/usr/bin/env ruby

require 'io/console'
require_relative 'lib/core'

def runner_factory(player, type)
  type.new(name: player.name)
end

def starting_position(player, circle)
  index = circle.find_index(player)
  raise IndexError if index.to_i >= circle.length - 1
  rescue StandardError
    index = circle.length - 2
  else
    index
end

circle = [
    Dog.new(name: "Paul"), 
    Dog.new(name: "Mattie"), 
    Dog.new(name: "Shane"), 
    Dog.new(name: "Justin"), 
    Dog.new(name: "Jordy")
]

circle.each { |p| p.position = circle.find_index(p) }

# get a random player to be the first runner
selected_player = circle.sample
game_on = true

while game_on
  puts "#{selected_player.name} is the runner"
  start_point = starting_position(selected_player, circle)
  runner = runner_factory(selected_player, Goose)
  runner.position = start_point
  circle.delete(selected_player)
  puts 

  loop do
    keypress = STDIN.getch
    puts "Duck..." if keypress == "\n"

    puts "Standing next to #{circle[runner.position].name}"

    case keypress
    when " "
      puts "Duck..."
      unless runner.position >= circle.length - 1
        runner.position += 1
      else 
        runner.position = 0
      end
      puts
    when "\r"
      puts "Goose!"
      puts
      chaser = circle[runner.position]

      if chaser.distracted?
        puts chaser.distracted
        puts "#{runner.name} made it back to #{chaser.name}'s spot safely!"
        circle << selected_player
        selected_player = chaser
        runner = nil
        break
      elsif chaser.chase >= runner.run
        puts "#{chaser.name} caught #{runner.name}!"
        puts "#{runner.name} is still the runner, starting a new round"
      else
        puts "#{runner.name} made it back to #{chaser.name}'s spot safely!"
        circle << selected_player
        selected_player = chaser
        runner = nil
        break
      end
      puts
    when "q"
      game_on = false
      break
    else
      puts "Not a valid option"
    end
  end
end

puts "Game over"
