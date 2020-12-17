#!/usr/bin/env ruby

require 'advent_11'

FILE = File.readlines('input/17_input.txt').map(&:strip)

ACTIVE = '#'.freeze
INACTIVE = '.'.freeze

def modified_directions
  directions = {}
  [0, 1, 2].each do |z|
    DIRECTIONS.each do |dir, coords|
      case z
      when 0
        dir = :"under_#{dir}"
      when 1
        dir = :"flat_#{dir}"
      when 2
        dir = :"over_#{dir}"
      end

      directions[dir] = coords.unshift(z)
    end
  end
end

def blocks_adjacent_to(layer, row, column)
  blocks_around = {}

  DIRECTIONS.each do |direction, coords|
    z, x, y = coords
    new_row = row.dup
    new_column = column.dup
    new_layer = layer.dup

    block_found = nil

    while block_found.nil?
      new_row += x
      new_column += y
      new_layer += z

      new_row = prevent_negative_pointer(new_row)
      new_row = prevent_overflow_pointer(new_row) if new_row
      new_column = prevent_negative_pointer(new_column)
      new_layer = prevent_negative_pointer(new_layer)
      new_layer = prevent_overflow_pointer(new_layer)

      break if new_row.nil? || new_column.nil? || new_layer.nil?

      block_found = $layer[new_layer][new_row][new_column] #rescue nil
      break if block_found.nil?

      #block_found = nil if block_found == FLOOR && $first_seat
    end

    blocks_around[direction] = block_found
  end

  blocks_around.compact
end


def change_blocks(layer)
  $layers = [FILE.dup, File.dup, File.dup]

  blocks_changed = 1

  while blocks_changed > 0
    blocks_changed = 0
    this_round = $layers.clone.map(&:clone)

    $layers.each_with_index do |layer|
      layer.each_with_index do |block_row, row|
        0.upto(block_row.length - 1) do |column|
        case block_row[column]
          # when FLOOR
          #   next
          when INACTIVE
            unless adjacent_block_occupied?(layer, row, column)
              this_round[layer][row][column] = ACTIVE 
              blocks_changed += 1
            end
          when ACTIVE
            if too_many_blocks?(row, column)
              this_round[layer][row][column] = INACTIVE
              blocks_changed += 1
            end
          else
            raise "Unknown block type: #{block_row[column]}"
          end
        end
      end
    end

    $layers = this_round.dup.map(&:clone)
  end
