STARTING_NUMBERS = [2,0,1,9,5,19]

def calculate_next_number(finish)
  current_number = 0
  numbers = {}

  1.upto(finish) do |turn|
    if turn % 1_000_000 == 0
      puts "Turn: #{turn}"
    end
    previous_number = current_number.clone

    if turn <= STARTING_NUMBERS.size
      current_number = STARTING_NUMBERS[turn - 1]
    elsif turn == STARTING_NUMBERS.size + 1
      current_number = 0
    else
      if numbers.key?(previous_number) && numbers[previous_number].size > 1
        current_number = 
          numbers[previous_number].sort.last - numbers[previous_number].sort[-2]
      else
        current_number = 0
      end
    end

    numbers[current_number] ||= [];
    numbers[current_number] << turn

    while(numbers[current_number].size > 2) do
      numbers[current_number].delete(numbers[current_number][0])
    end
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