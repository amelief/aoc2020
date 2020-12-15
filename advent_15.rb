STARTING_NUMBERS = [2,0,1,9,5,19]

$numbers = {}

def number_spoken?(num)
  $numbers.keys.include?(num) && $numbers[num].size > 1
end

def number_mentioned_difference(num)
  $numbers[num].sort.last - $numbers[num].sort[-2]
end

def register_number(num, turn)
  $numbers[num] ||= [];
  $numbers[num] << turn

  while($numbers[num].size > 2) do
    $numbers[num].delete($numbers[num][0])
  end
end

def calculate_next_number(finish)
  current_number = 0

  1.upto(finish) do |turn|
    if turn % 10000 == 0
      puts "Turn: #{turn}"
    end
    previous_number = current_number.dup

    if turn <= STARTING_NUMBERS.size
      current_number = STARTING_NUMBERS[turn - 1]
    elsif turn == STARTING_NUMBERS.size + 1
      current_number = 0
    else
      if number_spoken?(previous_number)
        current_number = number_mentioned_difference(previous_number)
      else
        current_number = 0
      end
    end

    register_number(current_number, turn)
  end

  puts "Number is: #{current_number}"
end

1.upto(2) do |part|
  print "Part #{part}: "
  case part
  when 1
    calculate_next_number(2020)
  when 2
    calculate_next_number(30_000_000)
  end
end