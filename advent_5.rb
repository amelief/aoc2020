#!/usr/bin/ruby

F = File.read('input/5_input.txt').split("\n").map(&:strip)

CHAR_LIMIT_ROW = 6
CHAR_LIMIT_COL = 9

HIGHEST_ROW = 127
LOWEST_ROW = 0
HIGHEST_COL = 7
LOWEST_COL = 0

OUTPUT = "Highest seat ID: %d, your seat ID: %d"

multiply_num = 0

ids = all = []

F.each do |line|
  rownum_lowest = LOWEST_ROW
  rownum_highest = HIGHEST_ROW
  seatnum_lowest = LOWEST_COL
  seatnum_highest = HIGHEST_COL

  actual_row = actual_seat = nil

  line.split('').map(&:upcase).each_with_index do |char, i|

    case char
    when 'F'
      rownum_highest = rownum_lowest + ((rownum_highest - rownum_lowest + 1) / 2) - 1

      actual_row = rownum_lowest if i == CHAR_LIMIT_ROW

    when 'B'
      rownum_lowest = rownum_lowest + ((rownum_highest - rownum_lowest + 1) / 2)

      actual_row = rownum_highest if i == CHAR_LIMIT_ROW

    when 'L'
      seatnum_highest = seatnum_lowest + ((seatnum_highest - seatnum_lowest + 1) / 2) - 1

      actual_seat = seatnum_lowest if i == CHAR_LIMIT_COL

    when 'R'
      seatnum_lowest = seatnum_lowest + ((seatnum_highest - seatnum_lowest + 1) / 2)

      actual_seat = seatnum_highest if i == CHAR_LIMIT_COL

    else
      raise "Unknown character #{char}"
    end
  end

  raise " Didn't get a rownum" if actual_row.nil?
  raise " Didn't get a seatnum" if actual_seat.nil?
  
  sum = actual_row * 8 + actual_seat

  # Part 1
  multiply_num = sum if sum > multiply_num

  # Part 2
  ids << sum
end

# Part 2 continued

1.upto(multiply_num) { |i| all << i }

empty_seats = all - ids
empty_seats.delete_if { |val| val < ids.first } # anything lower than the first ID is not valid

raise 'Could not find your seat :(' if empty_seats.size > 1

puts sprintf(OUTPUT, multiply_num, empty_seats.join('').to_i)
