#!/usr/bin/ruby

MAP = File.read('input/3_input.txt').split("\n").map(&:strip)

TREE = '#'
NOT_TREE = '.'

DRAW_MAP = false # set to true to output map

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

  MAP.each_with_index do |line, line_no|

    unless line_no % part[:down] == 0
      puts line if DRAW_MAP
      next
    end

    line_length = line.length - 1

    if char_point > line_length
      extend_times = (char_point.to_f / line_length.to_f).ceil
      line = line * extend_times
    end

    draw_line = line.dup # use dup or result gets cached

    if line[char_point] == TREE
      part[:num_trees] += 1 
      draw_line[char_point] = 'X' if DRAW_MAP
    elsif line[char_point] == NOT_TREE
      draw_line[char_point] = 'O' if DRAW_MAP
    else
      puts "! Unexpected character #{line[char_point]}"
    end

    puts draw_line if DRAW_MAP

    char_point += part[:right]
  end

  puts "Slope #{slope_no + 1}: #{part[:num_trees]}"

  num_trees_multiplied *= part[:num_trees]
end

puts "Total trees multiplied: #{num_trees_multiplied}"