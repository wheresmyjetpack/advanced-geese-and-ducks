#!/usr/bin/env ruby

require 'io/console'
require_relative 'lib/core'
require_relative 'lib/helpers'

player_classes = [Duck, Dog, Cat]
obtainable_types = [Bicycle, Skateboard, Rollerblades]
class_hash = Hash[ (1...player_classes.size + 1).zip player_classes ]

puts "How many players?"
num_players = gets.to_i
puts
circle = Array.new
player_garages = Hash.new

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
  garage = Garage.new

  obtainable_types.each do |type|
    obtainables << type.new(garage: garage)
  end

  obtainables_hash = Hash[ (1...obtainables.size + 1).zip obtainables ]

  player_garages[player.name] = obtainables_hash
  puts
end

circle.each { |p| p.position = circle.find_index(p) }

# get a random player to be the first runner
selected_player = circle.sample   # this also will hold the Chaser object while that player is the runner
game_on = true
current_round = 1

while game_on
  puts "#{selected_player.name} is the runner"
  start_point = starting_position(selected_player, circle)
  runner = runner_factory(selected_player, Goose)
  runner.position = start_point
  circle.delete(selected_player)
  puts 

  loop do
    puts "Round: #{current_round}"
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
        chaser.repair_if_broken(current_round)
        puts "#{runner.name} is still the runner"
      else
        puts "#{runner.name} made it back to #{chaser.name}'s spot safely!"
        chaser.repair_if_broken(current_round)
        circle << selected_player
        selected_player.score
        puts "#{selected_player.name}'s points: #{selected_player.points}"
        if selected_player.points % 3 == 0
          puts "#{selected_player.name} gained enough points to acquire an item!"
          puts "Select an item from the menu:"
          puts
          puts player_garages[selected_player.name].map { |k, v| "#{k}) #{v.name}" }.join("\n") + "\n\n"
          obtainable = player_garages[selected_player.name][gets.to_i]
          puts "Selected the #{obtainable.name}"
          selected_player.obtain(obtainable, current_round)
        end
        selected_player = chaser
        runner = nil
        puts "Starting a new round"
        current_round += 1
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
