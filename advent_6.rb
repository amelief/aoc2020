#!/usr/bin/ruby

F = File.read('input/6_input.txt').split("\n\n").map(&:strip)
OUTPUT = "%s: sum is: %d"
PARTS = 2

sum_qs_anyone = sum_qs_everyone = 0

F.each do |group|
  PARTS.times do |part|

    case part
    when 0
      #part 1
      qs = group.split("\n").map(&:strip).join('') # get them all on one line
      qs = qs.split('').uniq

      sum_qs_anyone += qs.size
    when 1
      #part 2
      qs = group.split("\n").map(&:strip)
      answered_qs = qs[0].split('').uniq

      qs.each do |q|
        answered_qs = answered_qs & q.split('').uniq
      end

      sum_qs_everyone += answered_qs.size
    else
      raise 'Unknown part'
    end
  end
end

puts sprintf(OUTPUT, 'Part 1', sum_qs_anyone)
puts sprintf(OUTPUT, 'Part 2', sum_qs_everyone)

