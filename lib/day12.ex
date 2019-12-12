defmodule Day12 do

  def energy(positions, cycle) do
    moons = step(Enum.map(positions, fn(position) ->
      {position, {0,0,0}}
    end), cycle)
    Enum.sum(Enum.map(moons, fn({{x,y,z},{vx,vy,vz}}) ->
      (abs(x)+abs(y)+abs(z))*(abs(vx)+abs(vy)+abs(vz))
    end))
  end

  def step(moons, cycle \\ 1)
  def step(moons, 0), do: moons
  def step(moons, cycle) do
    new_moons = Enum.map(moons, fn({position, velocity}) ->
      new_velocity = new_velocity(velocity, position, moons)
      {add(position, new_velocity), new_velocity}
    end)
    step(new_moons, cycle - 1)
  end

  def origin(start), do: origin(start, start, 0)

  def origin(begining, begining, cycle) when cycle > 0, do: cycle
  def origin(begining, line_moons, cycle) do
    new_moons = Enum.map(line_moons, fn({position, velocity}) ->
      new_velocity = velocity + offset_line_velocity(position, line_moons)
      {position + new_velocity, new_velocity}
    end)
     origin(begining, new_moons, cycle+1)
  end

  def repeat(moons) do
    n1 = origin(Enum.map(moons, fn({x,_,_}) -> {x,0} end))
    n2 = origin(Enum.map(moons, fn({_,y,_}) -> {y,0} end))
    n3 = origin(Enum.map(moons, fn({_,_,z}) -> {z,0} end))
    lcm(n1, lcm(n2,n3))
  end

  def lcm(a,b), do: div(abs(a*b), Integer.gcd(a,b))

  defp add({x1,y1,z1}, {x2,y2,z2}), do: {x1+x2,y1+y2,z1+z2}

  defp new_velocity(velocity, position, moons) do
    add(velocity, offset_velocity(position, moons))
  end

  def offset_velocity({x,y,z}, moons) do
    xs = Enum.map(moons, fn({{x,_,_},_}) -> x end)
    ys = Enum.map(moons, fn({{_,y,_},_}) -> y end)
    zs = Enum.map(moons, fn({{_,_,z},_}) -> z end)
    {offset(x,xs), offset(y,ys), offset(z,zs)}
  end

  def offset_line_velocity(x, moons) do
    xs = Enum.map(moons, fn({x,_}) -> x end)
    offset(x,xs)
  end

  defp offset(x, xs) do
    List.foldl(xs, 0, fn(xn,acc) -> comparaison(x,xn) + acc end)
  end

  defp comparaison(x,x), do: 0
  defp comparaison(x1,x2) when x1 > x2, do: -1
  defp comparaison(_,_), do: 1
end
