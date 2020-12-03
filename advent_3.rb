#!/usr/bin/ruby

map = File.read('input/3_input.txt').split("\n").map(&:strip)

tree = '#'
not_tree = '.'

draw_map = false # set to true to output map

num_trees_multiplied = 1

parts = [
  { right: 1, down: 1, num_trees: 0 }, # 1
  { right: 3, down: 1, num_trees: 0 }, # 2 - original part 1
  { right: 5, down: 1, num_trees: 0 }, # 3
  { right: 7, down: 1, num_trees: 0 }, # 4
  { right: 1, down: 2, num_trees: 0 }  # 5
]

parts.each_with_index do |part, slope_no|
  char_point = 0

  map.each_with_index do |line, line_no|

    unless line_no % part[:down] == 0
      puts line if draw_map
      next
    end

    line_length = line.length - 1

    if char_point > line_length
      extend_times = (char_point.to_f / line_length.to_f).ceil
      line = line * extend_times
    end

    draw_line = line.dup # use dup or result gets cached

    if line[char_point] == tree
      part[:num_trees] += 1 
      draw_line[char_point] = 'X' if draw_map
    elsif line[char_point] == not_tree
      draw_line[char_point] = 'O' if draw_map
    else
      puts "! Unexpected character #{line[char_point]}"
    end

    puts draw_line if draw_map

    char_point += part[:right]
  end

  puts "Slope #{slope_no + 1}: #{part[:num_trees]}"

  num_trees_multiplied *= part[:num_trees]
end

puts "Total trees multiplied: #{num_trees_multiplied}"