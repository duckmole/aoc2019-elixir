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
    [operation, _, _ | tail] = Enum.map(String.split(code, ","), fn(l) -> integer(l) end)
    decode = [operation, 12, 2] ++ tail
    Enum.join(intcode(operation, 0, decode), ",")
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
    |> Stream.map(fn (line) -> IO.puts intcode(line, :alarm_1202) end)
    |> Stream.run
  end
end
