#!/usr/bin/ruby

F = File.read('input/7_input.txt').split("\n").map(&:strip)

YOUR_BAG = 'shiny gold'
NO_OTHER_BAGS = /no other bags/

$bag_hash = {}
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

def find_rule(colour)
  F.each do |rule|
    regex = /#{colour} bags contain (.*)/
    m = regex.match(rule)
    return m if m
  end
end


$rec = 0

def how_many_hash(colour)
  $rec += 1
  puts "-- RECURSING, looking at: #{colour}"
  
  in_this_bag = bag_value(colour, data = 0) || 0

  rule = find_rule(colour)
  raise "Rule not found for #{colour}" unless rule

  puts rule[0]

  other_bags = rule[1]
  if other_bags.match(NO_OTHER_BAGS)
    puts ' -- no bags here'
    in_this_bag = 1
  else
    other_bags = other_bags.split(',').map(&:strip)
    contains_bags = 0
    puts "&& #{other_bags.inspect}"

    other_bags.each do |bag|
      puts " - sub_bag: #{bag}"
      new_colour = /([a-z]+ [a-z]+) bags?/.match(bag)
      new_colour = new_colour[1]
      next if new_colour == colour
      num = /\d+/.match(bag)[0].to_i
      
      num_of_bags = bag_value(new_colour) || how_many_hash(new_colour)

      contains_bags = num unless find_rule(new_colour)[0].match(/no other bags/)
      puts "> #{num} of #{new_colour} (contains #{num_of_bags})"
      puts ">> #{contains_bags} + #{num}(#{num_of_bags})"

      num_of_bags = (num * num_of_bags) + contains_bags
      puts "   = #{num_of_bags}"

      in_this_bag += num_of_bags
      puts ">>> Current count is #{in_this_bag}"
    end
  end

  bag_value(colour, in_this_bag)
end

def bag_value(colour, data = nil)
  how_many_hash(colour) if data.nil? && $bag_hash.empty?
  colour = colour.to_sym
  if data && data > 0
    $bag_hash[colour] = data unless $bag_hash[colour]
  end
  $bag_hash[colour]
end

puts bag_value(YOUR_BAG)
puts $bag_hash.inspect
puts $rec