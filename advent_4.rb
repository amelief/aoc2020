#!/usr/bin/ruby

DATA_FILE = File.read('input/4_input.txt').split("\n\n").map(&:strip)

VALIDATION = {
  hgt: /^(1([5-8][0-9]|9[0-3])cm|(59|6[0-9]|7[0-6])in)$/,
  byr: /^[1-2](9[2-9][0-9]|00[0-2])$/,
  iyr: /^20(1[0-9]|20)$/,
  eyr: /^20(2[0-9]|30)$/,
  hcl: /^#[0-9a-f]{6}$/,
  ecl: /^(amb|blu|brn|gry|grn|hzl|oth)$/,
  pid: /^[0-9]{9}$/
}

OUTPUT = "Valid: %d, invalid: %d"

VALIDATE_DATA = true # set to false for part 1

valid = 0
invalid = 0

def validate_required_fields?(data)
  matches = true

  VALIDATION.each do |key, regex|

    if data.include?(key.to_s)
      next unless VALIDATE_DATA
      
      data_item = data.split(' ')

      data_item.each do |item|
        data_key, data_value = item.split(':')
        next unless data_key.to_s == key.to_s

        matches = false unless regex.match(data_value)
      end

    else
      matches = false 
    end
  end

  matches
end

DATA_FILE.each do |p|
  p = p.split("\n").join(' ')
  validate_required_fields?(p) ? valid += 1 : invalid += 1
end

puts sprintf(OUTPUT, valid, invalid)