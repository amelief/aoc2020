#!/usr/bin/env ruby

FILE = File.read('input/16_input.txt').split("\n\n").map(&:strip)

VALIDATIONS = FILE[0].split("\n").map(&:strip)
YOUR_TICKET = FILE[1].split("\n")[1]
NEARBY_TICKETS = FILE[2].split("\n").reject { |x| x.match(/^nearby/) }

$validations = {}

VALIDATIONS.each do |v|
  description, rules = v.split(':').map(&:strip)

  description.gsub!(/ /, '_')

  $validations[description] = []

  rules.split('or').map(&:strip).each_with_index do |rule, i|
    $validations[description][i] = rule.split('-').map(&:to_i)
  end
end

def validate_rule(rule_name, num)
  rule = $validations[rule_name.gsub(/ /, '_')]

  is_valid = false
  if (num >= rule[0][0] && num <= rule[0][1]) || (num >= rule[1][0] && num <= rule[1][1])
    is_valid = true
  end
  is_valid
end

def valid_for_any_field?(num)
  $validations.keys.each do |v|
    return true if validate_rule(v, num)
  end
  false
end

def valid_for_all_fields?(ticket, rules)
  fields = ticket.split(',').map(&:to_i)
  rules.each_with_index do |v, i|
    unless validate_rule(v, fields[i])
      return false 
    end
  end
  true
end

def get_invalid_tickets_and_fields
  invalid_tickets = []
  invalid_fields = []

  NEARBY_TICKETS.each do |ticket|
    ticket.split(',').map(&:to_i).each do |field|
      unless valid_for_any_field?(field)
        invalid_fields << field 
        invalid_tickets << ticket unless invalid_tickets.include?(ticket)
      end
    end
  end

  { tickets: invalid_tickets.sort, fields: invalid_fields.sort }
end

def find_valid_combination(ticket)
  # expensive, but works...!
  rules = $validations.keys.clone
  rules.shuffle!
  rules.permutation.each do |combination|
    return combination if valid_for_all_fields?(ticket, combination)
  end
  raise 'did not find combination'
  nil
end

def part_2
  valid_tickets = NEARBY_TICKETS.sort - get_invalid_tickets_and_fields[:tickets]

  # This is the one we want
  # combination = [
  #   'class', 'departure_track', 'departure_location', 'arrival_platform',
  #   'arrival_station', 'zone', 'departure_time', 'price',
  #   'seat', 'row', 'type', 'train', 'wagon', 'route',
  #   'departure_station', 'arrival_track', 'departure_platform',
  #   'departure_date', 'arrival_location', 'duration'
  # ]

  combination = find_valid_combination(valid_tickets.first)

  correct_combinations = 0

  # Make sure it's valid on our ticket too
  valid_tickets.unshift(YOUR_TICKET)

  while correct_combinations < (valid_tickets.size - 5) do
    correct_combinations = 0
    valid_tickets.each do |ticket|
      if valid_for_all_fields?(ticket, combination)
        correct_combinations += 1
      else
        correct_combinations = 0
        combination = find_valid_combination(ticket)
      end
    end
  end

  departure_values = []
  fields = YOUR_TICKET.split(',').map(&:to_i)
  combination.each_with_index do |label, i|
    next unless label.start_with?('departure')
    departure_values << fields[i]
  end

  puts departure_values.reduce(&:*)
end

def part_1
  puts get_invalid_tickets_and_fields[:fields].sum
end

1.upto(2) do |part|
  print "Part #{part}: "
  send("part_#{part}")
end