def test
  lines_1 = to_lines("R8,U5,L5,D3")
  lines_2 = to_lines("U7,R6,D4,L4")

  p1 = { x: 0, y: 0 }
  p2 = { x: 10, y: 0 }
  p3 = { x: 2, y: -10 }
  p4 = { x: 2, y: 10 }
  p5 = { x: 10, y: 0 }
  p6 = { x: 10, y: 5 }
  puts 'intersect'
  puts intersect(p1, p2, p3, p4) || 'no'
  puts intersect(p1, p2, p2, p1) || 'no'
  puts intersect(p3, p4, p3, p4) || 'no'
  puts intersect(p1, p2, p5, p6) || 'no'
end

def intersect(p1, p2, p3, p4)
  return nil if is_horizontal(p1, p2) && is_horizontal(p3, p4)
  return nil if is_vertical(p1, p2) && is_vertical(p3, p4)

  if is_horizontal(p1, p2)
    { x: p3[:x], y: p1[:y] } if (p1[:x]..p2[:x]).include?(p3[:x]) || (p2[:x]..p1[:x]).include?(p3[:x])
  else
    { x: p1[:x], y: p3[:y] } if (p1[:y]..p2[:y]).include?(p3[:y]) || (p2[:y]..p1[:y]).include?(p3[:y])
  end
end

def is_horizontal(p1, p2)
  p1[:y] == p2[:y]
end

def is_vertical(p1, p2)
  !is_horizontal(p1, p2)
end

def to_lines(string)
  lines = [{x:0, y:0}]
  string.split(',').each do |command|
    direction = command[0]
    length = command[1..-1].to_i
    last = lines.last
    case direction
      when 'R'
        lines << {x: last[:x] + length, y: last[:y]}
      when 'L'
        lines << {x: last[:x] - length, y: last[:y]}
      when 'U'
        lines << {x: last[:x], y: last[:y] + length }
      when 'D'
        lines << {x: last[:x], y: last[:y] - length }
    end
  end
  lines
end

test
