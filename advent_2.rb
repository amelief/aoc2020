#!/usr/bin/ruby

PWS = File.read('input/2_input.txt').split("\n").map(&:strip)

output = { part1: { valid: 0, invalid: 0 }, part2: { valid: 0, invalid: 0 }}

PWS.each do |p|
  policy, password = p.split(': ').map(&:strip)
  count, letters = policy.split(' ')
  num1, num2 = count.split('-').map(&:to_i)
  letter_count = password.count(letters.gsub(/[^a-zA-Z]/, ''))
  
  # Part 1
  if letter_count >= num1 && letter_count <= num2
    output[:part1][:valid] += 1
  else
    output[:part1][:invalid] += 1
  end

  # Part 2
  if (password[num1 - 1] == letters) ^ (password[num2 - 1] == letters)
    output[:part2][:valid] += 1
  else
    output[:part2][:invalid] += 1
  end

end

output.each do |k,v|
  puts "#{k}:"
  v.each do |kk,vv|
    puts "#{kk}: #{vv}"
  end
end