defmodule Day10 do

  def visibility(map) do
    asteroid_map = asteroids(map)
    Enum.map(asteroid_map, fn(origin) ->
      {visible_asteroids(map, origin), origin}
    end) |> Enum.sort |> List.last
  end

  def visible_asteroids(map, origin) do
    asteroid_map = asteroids(map)
    length(Enum.filter(asteroid_map, fn(dest) ->
          case dest do
            ^origin -> false
            dest -> visible(origin, dest, asteroid_map)
          end
        end))
  end

  def run_part2(map) do
    {{x_origin, y_origin}, _} = Day10.station_asteroids(map)
    v = vectors(map)
    {x,y} = parse(Enum.reverse(Enum.sort(Map.keys(v))), v, 1)
    100*(x_origin+x)+(y_origin-y)
  end

  def parse([], v, index), do: parse(Enum.reverse(Enum.sort(Map.keys(v))), v, index)
  def parse([key| tail], v, 199) do
    [{x,y}| asteroids] = v[key]
    {x,y}
  end
  def parse([key| tail_key], v, index) do
    [{x,y}| asteroids] = v[key]
    new_v = case asteroids do
              [] ->
                Map.drop(v, [key])
                _ -> %{v | key => asteroids}
              end
    parse(tail_key, new_v, index+1)
  end

  def station_asteroids(map) do
    {List.first(asteroids(String.split(map), 0, [], "X")), asteroids(String.split(map), 0, [], "#")}
  end

  def vectors(map) do
    { {x_base, y_base } , asteroids } = station_asteroids(map)
    result = Enum.map(asteroids, fn({x,y}) ->
      vector = {v_x, v_y} = {x - x_base, y_base - y }
      case  v_x do
        0 -> {{v_x >= 0 , 1000}, vector}
        _ -> {{v_x >= 0, v_y/v_x}, vector}
      end
    end
    )
    Enum.group_by(result, fn({x,y}) -> x end, fn({x,y}) -> y end )
  end

  def asteroids(map) do
    asteroids(String.split(map), 0, [], "#")
  end

  def asteroids([], _, acc, pattern) do
    acc
  end
  def asteroids([line|tail], line_nb,acc, pattern) do
    asteroids(tail, line_nb + 1, asteroids_in_line(String.split(line, ""), line_nb, -1, [], pattern)  ++ acc,
      pattern)
  end
  def asteroids_in_line([], _, _, acc, pattern), do: acc
  def asteroids_in_line([pattern|tail], line_nb, col_nb, acc, pattern) do
    asteroids_in_line(tail, line_nb, col_nb+1, [{col_nb, line_nb} | acc], pattern)
  end
  def asteroids_in_line([_|tail], line_nb, col_nb, acc, pattern) do
    asteroids_in_line(tail, line_nb, col_nb+1, acc, pattern)
  end

  def visible(origin, origin, _), do: false
  def visible({x_origin,y_origin}, {x_dest, y_dest}, asteroid_map) do
    max = case abs(x_origin-x_dest) > abs(y_origin-y_dest) do
            true -> x_origin-x_dest
            false -> y_origin-y_dest
          end
    case abs(max) do
      1 -> true
      _ ->
        step_x = (x_origin-x_dest) / max
        step_y = (y_origin-y_dest) / max
        period = case max > 0 do
                   true -> 1..max-1
                   _ -> -1..max+1
                 end
        Enum.filter(period, fn(n) ->
          x = x_origin - step_x * n
          y = y_origin - step_y * n
          case {round(x) == x, round(y) == y} do
            {true, true} ->
              Enum.member?(asteroid_map, {round(x), round(y)}
            _ -> false
          end
        end) == []
    end
  end
end
