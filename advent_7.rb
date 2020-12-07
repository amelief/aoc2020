#!/usr/bin/ruby

F = File.read('input/7_input.txt').split("\n").map(&:strip)

YOUR_BAG = 'shiny gold'

$processed = []

def contains_gold_bag(rules, colour)
  count = 0
  regex = /([a-z]+ [a-z]+) bags contain .* (#{colour}) .*/

  rules.each do |rule|
    matches = regex.match(rule)

    if matches
      new_colour = matches[1]

      unless $processed.include?(new_colour)
        $processed << new_colour
        count += 1
        count += contains_gold_bag(F, new_colour)
      end
    end
  end

  return count
end

def how_many_bags(colour)
  return $bag_hash[colour.to_sym]
end

$bag_hash = {}

def find_rule(colour)
  F.each do |rule|
    regex = /#{colour} bags contain (.*)/
    return rule if regex.match(rule)
  end
end

def how_many_hash(rules, colour)
  puts "-- RECURSING, I want #{colour}"
  return $bag_hash[colour.to_sym] if $bag_hash[colour.to_sym]
  in_this_bag = 0
  regex = /#{colour} bags contain (.*)/

  contains_bags = 0

  rules.each do |rule|
    m = regex.match(rule)
    next unless m

    puts rule

    other_bags = m[1].split(',').map(&:strip)
    contains_bags = 0

    other_bags.each do |bag|
      if /no other bags/.match(bag)
        in_this_bag += 1
        contains_bags = 0
      else
        new_colour = /([a-z]+ [a-z]+) bags?/.match(bag)
        new_colour = new_colour[1]
        num = /\d+/.match(bag)[0].to_i
        
        num_of_bags = how_many_hash(F, new_colour)
        puts "> #{num} of #{new_colour} (contains #{num_of_bags})"

        contains_bags = num unless find_rule(new_colour).match(/no other bags/)
        puts "contains bags: #{contains_bags}"

        num_of_bags = (num * num_of_bags) + contains_bags
        puts "num_of_bags: #{num_of_bags}"

        in_this_bag += num_of_bags
        puts "Current count is #{in_this_bag}"
      end
    end

  end
  $bag_hash[colour.to_sym] = in_this_bag
  return in_this_bag
end


  colour = YOUR_BAG
  how_many_hash(F, colour)
  puts how_many_bags(colour)
puts $bag_hash.inspect