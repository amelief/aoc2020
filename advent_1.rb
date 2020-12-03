#!/usr/bin/ruby

NUMBERS = File.read('input/1_input.txt').split("\n").map(&:to_i)

PARTS = 2
TARGET = 2020

OUTPUT = '%s match. Multiplied together, they make: %d'

def loop_numbers(&block)
  NUMBERS.each do |n|
    yield(n)
  end
end

PARTS.times do |i|
  loop_numbers do |num|
    loop_numbers do |num2|
      if i == 0 # part 1
        puts sprintf(OUTPUT, "#{num} + #{num2}", (num * num2)) if num + num2 == TARGET
      elsif i == 1 # part 2
        loop_numbers do |num3|
          if num + num2 + num3 == TARGET
            puts sprintf(OUTPUT, "#{num} + #{num2} + #{num3}", (num * num2 * num3))
          end
        end
      end
    end
  end
end