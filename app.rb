#!/usr/bin/env ruby

require 'io/console'
require './lib/core'
require './lib/helpers'
require './lib/config'

player_classes = [Duck, Dog, Cat]

class_hash = Hash[ (1...player_classes.size + 1).zip player_classes ]

puts "How many players?"
num_players = gets.to_i
puts
circle = Array.new
player_garages = Hash.new

obtainable_types = {
  Bicycle => ObtainableConfig.bicycle_config, 
  Skateboard => ObtainableConfig.skateboard_config,
  Rollerblades => ObtainableConfig.rollerblades_config
}

num_players.times do
  puts "Player Name:"
  name = gets.chomp
  puts
  puts "Select a player class from the list below by entering the corresponding number:\n"
  puts class_hash.map { |x| x * ") " }.join("\n") + "\n\n"
  class_num = gets.to_i
  player = player_factory(name, class_hash[class_num]) 
  circle << player

  obtainables = Array.new
  garage = KnowsRound::Garage.new

  obtainable_types.each do |type, config|
    obtainables << type.new(
      garage: garage,
      parts: PartsFactory.build(config)
    )
  end

  obtainables_hash = Hash[ (1...obtainables.size + 1).zip obtainables ]

  player_garages[player.name] = obtainables_hash
  puts
end

circle.each { |p| p.position = circle.find_index(p) }

# get a random player to be the first runner
selected_player = circle.sample   # this also will hold the Chaser object while that player is the runner
game_on = true
include KnowsRound
KnowsRound.current_round = 1
failures = 0

while game_on
  puts "#{selected_player.name} is the runner"
  start_point = starting_position(selected_player, circle)
  runner = runner_factory(selected_player, Goose)
  runner.position = start_point
  circle.delete(selected_player)
  puts 

  loop do
    puts "Round: #{KnowsRound.current_round}"
    next_to = circle[runner.position]
    player_type = next_to.class
    puts "Standing next to #{next_to.name}"
    keypress = STDIN.getch

    case keypress

    when " "
      puts "#{player_type}..."
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

      if chaser.catches?(runner)
        puts "#{chaser.name} caught #{runner.name}!"
        puts "#{runner.name} is still the runner"
        failures += 1

        if failures == 3
          puts
          puts "*** #{runner.name} was caught too many times, they lose a point! ***" 
          selected_player.lose_point
          failures = 0
        end

      else
        puts "#{runner.name} made it back to #{chaser.name}'s spot safely!"
        circle << selected_player
        selected_player.score
        puts "#{selected_player.name}'s points: #{selected_player.points}"

        if selected_player.points % 3 == 0 && selected_player.points != 0
          puts "#{selected_player.name} gained enough points to acquire an item!"
          puts "Select an item from the menu:"
          puts
          puts player_garages[selected_player.name].map { |k, v| "#{k}) #{v.name}" }.join("\n") + "\n\n"
          obtainable = player_garages[selected_player.name][gets.to_i]
          if obtainable.obtainable?
            selected_player.obtain(obtainable)
            puts "Selected the #{obtainable.name}"
          else
            puts "That item is unavailable right now!"
            puts
          end
        end

        selected_player = chaser
        runner = nil
        puts "Starting a new round"
        KnowsRound.current_round += 1
        failures = 0
        puts "=" * 16
        puts
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
