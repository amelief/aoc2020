#!/usr/bin/env ruby

F = File.readlines('input/13_input.txt').map(&:strip)

MY_TIME = F[0].to_i
BUSES = F[1].split(',').map(&:to_i).reject(&:zero?)

def calculate_closest_time(bus_interval)
  multiplier = (MY_TIME.to_f / bus_interval.to_f).ceil
  multiplier * bus_interval
end

def part_1
  time_and_bus = []

  BUSES.each do |bus|
    time = calculate_closest_time(bus)
    time_to_wait = time - MY_TIME

    if time_and_bus.empty? || time_to_wait < time_and_bus[1]
      time_and_bus = [bus, time_to_wait]
    end
  end

  puts time_and_bus[0] * time_and_bus[1]
end

def part_2
  # Nope! Didn't manage that one. :(
  puts ':('
end

1.upto(2) do |part|
  print "Part #{part}: "
  send("part_#{part}")
end