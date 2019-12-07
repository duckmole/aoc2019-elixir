defmodule Day6 do

  def run(path) do
    path |> File.read!() |> nb_orbits()
  end

  def run2(path) do
    path |> File.read!() |> nb_orbits()
  end

  def nb_orbits(string) do
    orbits = do_orbits(String.split(string, "\n"))
    orbits_with_sum = sum_orbits(Map.keys(orbits), orbits)
    List.foldl(Map.values(orbits_with_sum), 0, fn {_, nb}, acc -> nb + acc end)
  end

  def do_orbits(orbits, map \\ %{})
  def do_orbits([""], map) do
    map
  end
  def do_orbits([], map) do
    map
  end
  def do_orbits([orbit | tail], map) do
    [planet1, planet2] = String.split(orbit, ")")
    do_orbits(tail, Map.merge(map, %{planet2 => planet1}))
  end

  def sum_orbits([], orbits) do
    orbits
  end
  def sum_orbits([planet | tail], orbits) do
    new_orbits = case Map.get(orbits, planet) do
                   nil -> orbits
                   planet2 ->
                     sum_orbits([planet2], %{orbits | planet => { planet2, 1 }})
                   {planet2, nb} ->
                     sum_orbits([planet2], %{orbits | planet => { planet2, (nb + 1) }})
                 end
    sum_orbits(tail, new_orbits)
  end
  def way(string, dest) do
    orbits = do_orbits(String.split(string, "\n"))
    do_way(orbits, dest)
  end

  def do_way(orbits, dest, acc \\ [])
  def do_way(orbits, nil, acc) do
    acc
  end
  def do_way(orbits, dest, acc) do
    do_way(orbits, Map.get(orbits, dest), [dest | acc])
  end

  def to_santa(string) do
    orbits = do_orbits(String.split(string, "\n"))
    length(do_way(orbits, "SAN") -- do_way(orbits, "YOU")) +
    length(do_way(orbits, "YOU") -- do_way(orbits, "SAN")) - 2
  end
end
