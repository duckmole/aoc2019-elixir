defmodule Secure do

  def integer(string) do
    {value, _} = Integer.parse(string)
    value
  end

  def number(string) do
    Enum.map(String.graphemes(string), fn(x) -> integer(x) end)
  end

  def increment(true), do: 1
  def increment(false), do: 0

  def valid(string) do
    do_valid(number(string))
  end

  def adjacent([a,b,c,d,e,f]) do
    (a == b) && (b != c) ||
    (b == c) && (c != d) && (b != a)||
    (c == d) && (d != e) && (c != b) ||
    (d == e) && (e != f) && (d != c) ||
    (e == f) && (e != d)
  end

  def increase([a,b,c,d,e,f]) do
    (a<=b) && (b<=c) && (c<=d) && (d<=e) && (e<=f)
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
