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

  def station_asteroids(map) do
    {List.first(asteroids(String.split(map), 0, [], "X")), asteroids(String.split(map), 0, [], "#")}
  end

  def vector(map) do
    { {x_base, y_base } , asteroids } = station_asteroids(map)
    Enum.map(asteroids, fn({x,y} ->
      case y do
        0 -> {{x/abs(x), 1000}, {x_base - x, y_base - y }}
        _ -> {{x/abs(x), x/y}, {x_base - x, y_base - y }}
      end
    )

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
  def asteroids_in_line([], _, _, acc, pattern) do
    acc
  end
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
              Enum.member?(asteroid_map, {round(x), round(y)})
            _ -> false
          end
        end) == []
    end
  end
end
