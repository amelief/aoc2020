#!/usr/bin/env ruby
F = File.readlines('input/14_input.txt').map(&:strip)

$current_mask = nil

def convert_to_binary(num)
  num.to_s(2)
end

def mask_number(num, version: 1)
  formatter = "%0#{$current_mask.length}b"
  binary_num = sprintf(formatter % num)
  mask = $current_mask.chars.reverse

  binary_num.reverse!
  
  ignore = version == 1 ? 'X' : '0'
  binary_num.each_char.with_index do |char,i|
    next if mask[i].upcase == ignore

    binary_num[i] = mask[i]
  end

  binary_num.reverse!
end

# Unfortunately this isn't all mine - had some help!
def get_combinations(binary_address)
  x_positions = []

  binary_address.each_char.with_index do |char, i|
    x_positions << i if char == 'X'
  end

  ['0', '1'].repeated_permutation(x_positions.size).map do |combination|
    combination.each_with_index do |c, i|
      binary_address[x_positions[i]] = c
    end
    decimalise(binary_address)
  end
end

def decimalise(binary_num)
  binary_num.to_i(2)
end

def part_1
  version = 1
  run(version)
end

def part_2
  version = 2
  run(version)
end

def run(version)
  sum_hash = {}
  F.each do |line|
    if line.start_with?('mask')
      $current_mask = line.split('=')[1].strip
      next
    end

    memory_addr, value = line.split('=').map { |s| s.strip.gsub(/[^0-9]/, '').to_i }

    case version
    when 1
      value = mask_number(value, version: version)
      sum_hash[memory_addr] = decimalise(value)

    when 2
      memory_addr = mask_number(memory_addr, version: version)

      get_combinations(memory_addr).each do |addr|
        sum_hash[addr] = value
      end
    end
  end

  puts sum_hash.values.sum
end


1.upto(2) do |part|
  print "Part #{part}: "
  send("part_#{part}")
end


