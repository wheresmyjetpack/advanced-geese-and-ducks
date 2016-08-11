#!/usr/bin/env ruby

require_relative 'lib/core'

circle = GameCircle.new
goose = Goose.new(name: "Paul", circle: circle)

circle.players = ["A", "b", goose, "d"]

puts "Starting position: "
puts goose.position

puts
5.times do 
  puts goose.pass
end
