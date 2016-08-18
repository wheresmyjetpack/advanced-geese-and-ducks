#!/usr/bin/env ruby

require 'io/console'
require_relative 'lib/core'
require_relative 'lib/helpers'

player_classes = [Duck, Dog, Cat]
class_hash = Hash[(1...player_classes.size + 1).zip player_classes]

puts "How many players?"
num_players = gets.to_i
puts
circle = Array.new

num_players.times do
  puts "Player Name:"
  name = gets.chomp
  puts
  puts "Select a player class from the list below by entering the corresponding number:\n"
  puts class_hash.map { |x| x * ") " }.join("\n") + "\n\n"
  class_num = gets.to_i
  circle << player_factory(name, class_hash[class_num]) 
  puts
end

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
