FILE = File.readlines('input/12_input.txt').map(&:strip)

FACING = {
  _0: :n,
  _90: :e,
  _180: :s,
  _270: :w,
}

INSTRUCTIONS = {
  n: { y: 1 },
  e: { x: 1 },
  s: { y: -1 },
  w: { x: -1 }
}

def calculate_angle(value)
  max = 360
  min = 0

  if value >= max
    value = value - max
    value = calculate_angle(value)
  elsif value < min
    value = max + value
    value = calculate_angle(value)
  end

  value
end

def move_ship_position(num)
  if $with_waypoint
    $current_position[:x] += ($waypoint_position[:x] * num)
    $current_position[:y] += ($waypoint_position[:y] * num)
  else
    instruction = INSTRUCTIONS[FACING["_#{$ship_heading.abs}".to_sym]]
    $current_position[instruction.keys[0]] += (num * instruction.values[0])
  end
end

def rotate(degrees)
  if $with_waypoint
    degrees += 360 if degrees < 0

    case degrees
    when 90
      new_x = $waypoint_position[:y]
      new_y = -$waypoint_position[:x]

    when 180
      new_x = -$waypoint_position[:x]
      new_y = -$waypoint_position[:y]

    when 270
      new_x = -$waypoint_position[:y]
      new_y = $waypoint_position[:x]
    else
      raise "Unknown degrees #{degrees}"
    end

    $waypoint_position = { x: new_x, y: new_y }
  else
    $ship_heading = calculate_angle($ship_heading + degrees)
  end
end

def move_ship
  FILE.each do |ins|
    direction = ins[0].downcase
    num = ins.gsub(/[^0-9]/, '').to_i

    case direction
    when 'f'
      move_ship_position(num)
    when *['l', 'r']
      num = -num if direction == 'l'
      rotate(num)
    else
      instruction = INSTRUCTIONS[direction.to_sym]
    end

    if instruction
      new_position = num * instruction.values[0]

      if $with_waypoint
        $waypoint_position[instruction.keys[0]] += new_position
      else
        $current_position[instruction.keys[0]] += new_position
      end
    end
  end

  puts $current_position[:x].abs + $current_position[:y].abs
end

1.upto(2) do |part|
  print "Part #{part}: "

  $current_position = { x: 0, y: 0 }
  $waypoint_position = { x: 10, y: 1 }

  $ship_heading = 90

  case part
  when 1
    $with_waypoint = false

    move_ship
  when 2
    $with_waypoint = true
    move_ship
  end
end