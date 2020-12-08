#!/usr/bin/ruby

F = File.readlines('input/8_input.txt').map(&:strip)
TOTAL_LINES = F.size
FAULTY_INSTRUCTIONS = %w(jmp nop)
DEBUG = false

def run_program(changed_instruction = {})
  processed = []
  current_instruction = 0
  acc = 0

  file = F.dup

  if changed_instruction.any?
    if file[changed_instruction[:line]] == changed_instruction[:from]
      file[changed_instruction[:line]] = changed_instruction[:to]
    else
      raise "Could not find #{changed_instruction[:from]} on line #{changed_instruction[:line]}"
    end
  end

  while current_instruction < TOTAL_LINES do
    instruction, num = file[current_instruction].split(' ').map(&:strip)
    num = num.to_i

    raise "Loop detected: acc value was #{acc}" if processed.include?(current_instruction)

    processed << current_instruction

    case instruction
    when 'acc'
      acc += num
      current_instruction += 1
    when 'jmp'
      current_instruction += num
    else
      current_instruction += 1
    end
  end
  puts "Program ran. Acc: #{acc}"
end

def does_program_complete?(changed_instruction)
  begin
    run_program(changed_instruction)
  rescue RuntimeError
    return false
  end
  true
end

1.upto(2) do |part|
  if part == 1
    begin
      run_program
    rescue => e
      puts "Part #{part}: #{e.message}"
    end
  else
    print "Part #{part}: " # don't want a new line

    F.each_with_index do |line, i|
      instruction = line[0..2]
      next unless FAULTY_INSTRUCTIONS.include?(instruction)

      changed_instruction = { 
        line: i, 
        from: line,
        to: line.gsub(/#{instruction}/, instruction == 'jmp' ? 'nop' : 'jmp')
      }

      if does_program_complete?(changed_instruction)
        puts "Program runs when changing #{changed_instruction.inspect}" if DEBUG
        return
      end
    end
  end
end