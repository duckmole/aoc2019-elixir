defmodule Secure do

  def integer(string) do
    {value, _} = Integer.parse(string)
    value
  end

  def number(string) do
    [0] ++ Enum.map(String.graphemes(string), fn(x) -> integer(x) end) ++
    [10]
  end

  def increment(true), do: 1
  def increment(false), do: 0

  def valid(string) do
    do_valid(number(string))
  end

  def adjacent(numbers) do
    adjacent(numbers, false)
  end

  def adjacent([_,_,_], acc) do
    acc
  end
  def adjacent([a,b,c,d|tail], acc) do
    adjacent( [b,c,d | tail], (a != b) && (b == c) && (c != d) || acc)
  end

  def increase(numbers) do
    increase(numbers, true)
  end

  def increase([_], acc) do
    acc
  end
  def increase([a,b| tail], acc) do
    increase([b|tail],(a<=b) && acc)
  end

  def do_valid(number) do
    increment(adjacent(number) && increase(number))
  end

  def valid_password(string) do
    [min, max] = Enum.map(String.split(string, "-"),
      fn(x) -> integer(x) end)
    Enum.sum(Enum.map(min..max, fn(code) -> valid("#{code}") end))
  end
end
