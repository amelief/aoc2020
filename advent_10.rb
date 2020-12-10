#!/usr/bin/ruby

$file = File.readlines('input/10_input.txt').map(&:to_i).unshift(0).sort
$file << $file.max + 3

MAX_JUMPS = 3

def find_all_adapters(current)
  suitable_adapters = $file.map do |adapter_voltage|
    adapter_voltage if adapter_voltage > current && adapter_voltage <= current + MAX_JUMPS 
  end.compact
end

def calculate_difference(old_adapter, new_adapter)
  new_adapter - old_adapter
end

def find_adapter_and_difference(current)
  chosen_adapter = find_all_adapters(current).min

  [chosen_adapter, calculate_difference(current, chosen_adapter)]
end

# part 1
def get_jump_totals
  jumps_1 = 0
  jumps_3 = 0

  $file.each_with_index do |voltage, i|
    next if voltage == $file.max # last result won't find a higher adapter
    adapter, difference = find_adapter_and_difference(voltage)

    unless difference <= MAX_JUMPS && difference > 0
      raise "Got an unknown difference #{difference}" 
    end

    eval "jumps_#{difference} += 1" unless difference == 2
  end

  jumps_1 * jumps_3
end

# Part 2
# I had some help with this one... >_<
def find_all_combinations
  total_voltages = $file.size;
  current = []
  current[total_voltages - 1] = 1

  (total_voltages - 2).downto(0) do |i|
    count = 0;
    j = i + 1
    while(j < total_voltages && $file[j] - $file[i] <= MAX_JUMPS) do
      count += current[j]
      j += 1
    end
    current[i] = count;
  end

  current.first
end

1.upto(2) do |part|
  print "Part #{part}: "
  case part
  when 1
    puts get_jump_totals
  when 2
    puts find_all_combinations
  end
end

