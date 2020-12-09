#!/usr/bin/ruby

F = File.readlines('input/9_input.txt').map(&:to_i)
PREAMBLE = 25

def valid_number?(position)
  target_num = F[position]

  end_at = position - 1
  start_at = end_at - PREAMBLE

  start_at.upto(end_at) do |new_number|
    start_at.upto(end_at) do |new_number2|
      next if F[new_number] == F[new_number2]
      return true if [F[new_number], F[new_number2]].sum == target_num
    end
  end
  false
end

# Part 1
def get_target_num
  (PREAMBLE + 1).upto(F.size - 1) do |i|
    return F[i] unless valid_number?(i)
  end
  return nil
end

def contiguous_makes_target?(position)
  start_at = position
  nums_used = []

  position.upto(F.size - 1) do |i|
    num_sum = nums_used.sum

    if num_sum > $target
      return false
    elsif num_sum == $target
      weakness = [nums_used.min, nums_used.max].sum
      puts "Reached target number. Weakness: #{weakness}"
      return true
    else
      nums_used << F[i]
    end
  end

  false
end

$target = get_target_num

1.upto(2) do |part|
  case part
  when 1
    puts "Part #{part}: First invalid number is #{$target}"
  when 2
    print "Part #{part}: "
    F.each_with_index do |num1, i|
      return if contiguous_makes_target?(i)
    end
  end
end