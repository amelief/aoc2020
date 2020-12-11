#!/usr/bin/env ruby

F = File.readlines('input/11_input.txt').map(&:strip)
FLOOR = '.'.freeze
EMPTY = 'L'.freeze
OCCUPIED = '#'.freeze
TOO_CROWDED_LIMIT = 4

DIRECTIONS = {
  top: [-1, 0],
  top_right: [-1, 1],
  right: [0, 1],
  bottom_right: [1, 1],
  bottom: [1, 0],
  bottom_left: [1, -1],
  left: [0, -1],
  top_left: [-1, -1]
}

$first_seat = false

def prevent_negative_pointer(value)
  value < 0 ? nil : value
end

def prevent_overflow_pointer(value)
  value >= F.size ? nil : value
end

def seats_adjacent_to(row, column)
  seats_around = {}

  DIRECTIONS.each do |direction, coords|
    x, y = coords
    new_row = row.dup
    new_column = column.dup

    seat_found = nil

    while seat_found.nil?
      new_row += x
      new_column += y

      new_row = prevent_negative_pointer(new_row)
      new_row = prevent_overflow_pointer(new_row) if new_row
      new_column = prevent_negative_pointer(new_column)

      break if new_row.nil? || new_column.nil?

      seat_found = $seats[new_row][new_column] #rescue nil
      break if seat_found.nil?

      seat_found = nil if seat_found == FLOOR && $first_seat
    end

    seats_around[direction] = seat_found
  end

  seats_around.compact
end

def occupied_seats_adjacent_to(row, column)
  seats_adjacent_to(row, column).map { |key, value| value if value && value == OCCUPIED }.compact
end

def adjacent_seat_occupied?(row, column)
  occupied_seats_adjacent_to(row, column).any?
end

def too_crowded?(row, column)
  too_crowded_limit = ($first_seat ? TOO_CROWDED_LIMIT + 1 : TOO_CROWDED_LIMIT)
  seats = occupied_seats_adjacent_to(row, column)

  seats.size >= too_crowded_limit
end

def get_all_occupied_seats
  occupado = 0
  occupado += $seats.map { |seat_row| seat_row.gsub(/[^#]/, '').length }.sum
end

def change_seats
  $seats = F.dup

  seats_changed = 1

  while seats_changed > 0
    seats_changed = 0
    this_round = $seats.clone.map(&:clone)

    $seats.each_with_index do |seat_row, row|
      0.upto(seat_row.length - 1) do |column|
        case seat_row[column]
        when FLOOR
          next
        when EMPTY
          unless adjacent_seat_occupied?(row, column)
            this_round[row][column] = OCCUPIED 
            seats_changed += 1
          end
        when OCCUPIED
          if too_crowded?(row, column)
            this_round[row][column] = EMPTY
            seats_changed += 1
          end
        else
          raise "Unknown seat type: #{seat_row[column]}"
        end
      end
    end

    $seats = this_round.dup.map(&:clone)
  end

  "Occupied seats: #{get_all_occupied_seats}"
end

def part_1
  $first_seat = false
  change_seats
end

def part_2
  $first_seat = true
  change_seats
end

1.upto(2) do |part|
  print "Part #{part}: "
  eval("puts part_#{part}")
end