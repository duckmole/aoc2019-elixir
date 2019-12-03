defmodule Rocket do

  def base_full(mass) do
    trunc(mass / 3) - 2
  end

  def global_full(mass) do
    global_full(mass, 0)
  end

  def global_full(mass, acc) when mass <=6 do
    acc
  end

  def global_full(mass, acc) do
    current_mass = base_full(mass)
    global_full(current_mass, acc + current_mass)
  end

  def operation(operator, first, second, result) do
    operation(operator,
      Enum.at(result, first),
      Enum.at(result, second)
      )
  end
  def operation(1, first, second) do
    first + second
  end
  def operation(2, first, second) do
    first * second
  end

  def intcode(code, :alarm_1202) do
    intcode_with_noun_vern(code, 12, 2)
  end

  def intcode_with_noun_vern(expected, code) do
    intcode_with_noun_vern(expected, intcode_with_noun_vern(code, 0, 0), code, 0, 0)
  end

  def intcode_with_noun_vern(expected, expected, _, noun, verb) do
    100*noun + verb
  end
  def intcode_with_noun_vern(expected, _, code, 100, verb) do
    intcode_with_noun_vern(expected,
      intcode_with_noun_vern(code, 0, verb+1),
      code,
      0,
      verb+1)
  end
  def intcode_with_noun_vern(expected, _, code, noun, verb) do
    intcode_with_noun_vern(expected,
      intcode_with_noun_vern(code, noun+1, verb),
      code,
      noun+1,
      verb)
  end

  def intcode_with_noun_vern(code, noun, verb) do
    [operation, _, _ | tail] = Enum.map(String.split(code, ","), fn(l) -> integer(l) end)
    decode = [operation, noun, verb] ++ tail
    List.first(intcode(operation, 0, decode))
  end

  def intcode(code) do
    decode = Enum.map(String.split(code, ","), fn(l) -> integer(l) end)
    Enum.join(intcode(List.first(decode), 0, decode), ",")
  end

  def intcode(99, _, result) do
    result
  end

  def intcode(operator, index, result) do
    first = Enum.at(result, index + 1)
    second = Enum.at(result, index + 2)
    dest = Enum.at(result, index + 3)

    value = operation(operator, first, second, result)
    new_result = Enum.concat(Enum.concat(Enum.take(result, dest), [value]),
      Enum.take(result, dest + 1 - length(result)))
    intcode(Enum.at(new_result, index + 4), index + 4, new_result)
  end

  def integer(string) do
    {value, _} = Integer.parse(string)
    value
  end

  def total do
    File.stream!("day1.txt")
    |> Stream.map(&String.strip/1)
    |> Stream.map(fn (line) -> global_full(integer(line)) end)
    |> Enum.sum
  end

  def alarm_1202 do
    File.stream!("day2.txt")
    |> Stream.map(&String.strip/1)
    |> Stream.map(fn (line) -> intcode_with_noun_vern(line, 12, 2) end)
    |> Enum.sum
  end

  def noun_verb(expected) do
    File.stream!("day2.txt")
    |> Stream.map(&String.strip/1)
    |> Stream.map(fn (line) -> intcode_with_noun_vern(expected, line) end)
    |> Enum.sum
  end

  def offset("R") do
    [1, 0]
  end
  def offset("L") do
    [-1, 0]
  end
  def offset("U") do
    [0, 1]
  end
  def offset("D") do
    [0, -1]
  end

  def line([x,y], <<direction :: binary-size(1)>> <> length ) do
    [offset_x, offset_y] = offset(direction)
    Enum.map((1..integer(length)), fn(i) ->
      [x+i*offset_x, y+i*offset_y]
    end)
  end

  def points(limits) do
    points([[0,0]], limits)
  end

  def points(all_points, []) do
    all_points
  end

  def points(current_points, [direction | tail]) do
    points(current_points ++ line(List.last(current_points), direction), tail)
  end

  def string_to_points(string) do
    [string1, string2] = String.split(string, "\n")
    [points(String.split(string1, ",")), points(String.split(string2, ","))]
  end

  def intersections(points1, points2) do
    points3 = points1 -- points2
    [ _ | intersect ] = points1 -- points3
    intersect
  end

  def closest_wire(string) do
    [points1, points2] = string_to_points(string)
    Enum.min(Enum.map(intersections(points1, points2), fn([x,y]) -> abs(x) + abs(y) end))
  end

  def update_number(false, _, _, steps) do
    steps
  end
  def update_number(true, point, length, steps) do
    Map.put(steps, point, length + steps[point])
  end
  def step([], _, _, step_numbers) do
    step_numbers
  end
  def step([point | tail] , intersect, length, steps) do
    new_steps = update_number(Enum.member?(intersect, point), point, length, steps)
    step(tail, intersect, length + 1, new_steps)
  end

  def lower_step(string) do
    [points1, points2] = string_to_points(string)
    intersect = intersections(points1, points2)
    steps = Map.new(Enum.map(intersect, fn(x) -> {x, 0} end))
    step_numbers = step(points1, intersect, 0, steps)
    Enum.min(Map.values(step(points2, intersect, 0, step_numbers)))
  end
end
