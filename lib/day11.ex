defmodule Day11 do

  def run(puzzle, start_color) do
    robot = spawn(fn -> loop({{0,0}, :up}, %{}, :color, nil) end)
    program = spawn(fn -> intcode(puzzle, robot, nil) end)
    send(robot, {:state, {:start, program}})
    send(program, {:input, start_color})
  end

  def direction({{x, y}, :up}, 0), do: {{x - 1, y}, :left}
  def direction({{x, y}, :up}, 1), do: {{x + 1, y}, :right}
  def direction({{x, y}, :left}, 0), do: {{x, y + 1}, :down}
  def direction({{x, y}, :left}, 1), do: {{x, y - 1}, :up}
  def direction({{x, y}, :down}, 0), do: {{x + 1, y}, :right}
  def direction({{x, y}, :down}, 1), do: {{x - 1, y}, :left}
  def direction({{x, y}, :right}, 0), do: {{x, y - 1}, :up}
  def direction({{x, y}, :right}, 1), do: {{x, y + 1}, :down}

  def loop(robot={position={x,y}, _}, map, wait_for, program) do
    receive do
      {:input, input} ->
        case wait_for do
          :direction ->
            new_direction = {position, _ }= direction(robot, input)
            send(program, {:input, map[position] || 0 })
            loop(new_direction, map, :color, program)
          :color ->
            loop(robot, Map.put(map, position, input), :direction, program)
        end
      {:state, :stop} -> image(map)
      {:state, {:start, pid}} -> loop(robot, map, wait_for, pid)
      unexpected -> IO.puts unexpected
    after 10000 -> image(map)
    end
  end

  def image(map) do
    max_x = Enum.max(Enum.map(Map.keys(map), fn({x,_}) -> x end))
    min_x = Enum.min(Enum.map(Map.keys(map), fn({x,_}) -> x end))
    max_y = Enum.max(Enum.map(Map.keys(map), fn({_,y}) -> y end))
    min_y = Enum.min(Enum.map(Map.keys(map), fn({_,y}) -> y end))
    IO.puts(length(Map.keys(map)))
    IO.puts("#{min_x} - #{max_x} | #{min_y} #{max_y}")
    image = Enum.join(Enum.map(min_y..max_y, fn(y) ->
          line = Enum.join(Enum.map((min_x..max_x), fn(x) ->
                case map[{x,y}] do
                  1 -> "#"
                  0 -> " "
                  _ -> " "
                end
              end))
          Enum.join([line,"\n"])
        end)
    )
    IO.puts image
  end


  def intcode(code, nil, thrusters_pid) do
    receive do
      {:pid, pid} -> intcode(code, pid, thrusters_pid)
    end
  end
  def intcode(code, child_pid, thrusters_pid) do
    decode = Enum.map(String.split(code, ","), fn(l) -> integer(l) end)
    intcode(List.first(decode), %{index: 0, relative_base: 0}, decode, %{child: child_pid, thrusters: thrusters_pid})
  end

  def value(opcode, indexes, index, program), do: Enum.at(program, address(opcode, indexes, index, program)) || 0

  def address(0, _, index, program), do: Enum.at(program, index) || 0
  def address(1, _, index, _), do: index
  def address(2, indexes, index, program), do: (Enum.at(program, index) || 0) + indexes[:relative_base]

  def update_program(value, dest, program) do
    max_heap = length(program)
    case dest < max_heap do
      true -> List.replace_at(program, dest, value)
      _ ->
        List.replace_at(Enum.concat(program, List.duplicate(0, dest - (max_heap-1) )),
          dest, value)
    end
  end

  def operation(1, first, second), do: first + second
  def operation(2, first, second), do: first * second
  def operation(7, first, second) when first < second, do: 1
  def operation(7, _, _),  do: 0
  def operation(8, first, first), do: 1
  def operation(8, _, _), do: 0

  def integer(string) do
    {value, _} = Integer.parse(string)
    value
  end

  def decompose_first(operator, indexes=%{ :index => index }, program) do
    c =  div(rem(operator, 1000),100)
    value(c, indexes, index + 1, program)
  end
  def decompose(operator, indexes=%{ :index => index }, program) do
    opcode = rem(operator, 100)
    c =  div(rem(operator, 1000),100)
    b = div(rem(operator, 10000),1000)
    a = div(operator, 10000)

    first = value(c, indexes, index + 1, program)
    second = value(b, indexes, index + 2, program)
    dest = address(a, indexes, index + 3, program)
    [opcode, first, second, dest]
  end

  def jump(5, 0, _, index), do: index
  def jump(5, _, second, _), do: second
  def jump(6, 0, second, _), do: second
  def jump(6, _, _, index), do: index

  def intcode(99, _indexes, program, pids) do
    case pids[:thrusters] do
      nil -> :ok
      pid -> send pid, {:state, :stop}
    end
    Enum.join(program, ",")
  end

  def intcode(operator, indexes=%{ :index => index }, program, pids) when rem(operator,100) == 3 do
    c = div(rem(operator, 1000),100)
    dest = address(c, indexes, index+1, program)
    receive do
      {:input, input} ->
        new_program = update_program(input, dest, program)
        new_indexes = %{indexes | index: index + 2}
        back(new_indexes, new_program, pids)
    end
  end
  def intcode(operator, indexes=%{ :index => index }, program, pids) when rem(operator,100) == 4 do
    first = decompose_first(operator, indexes, program)
    send(pids[:child], {:input, first})
    new_indexes = %{indexes | index: index + 2}
    back(new_indexes, program, pids)
  end
  def intcode(operator, indexes, program, pids) when rem(operator,100) == 5 or rem(operator,100) == 6 do
    [opcode, first, second, _] = decompose(operator, indexes, program)
    new_indexes = %{indexes | index: jump(opcode, first, second, indexes[:index] + 3)}
    back(new_indexes, program, pids)
  end
  def intcode(operator, indexes=%{ :relative_base => relative_base, :index => index }, program, pids) when rem(operator,100) == 9 do
    first = decompose_first(operator, indexes, program)
    new_indexes = %{relative_base: relative_base + first, index: index + 2}
    back(new_indexes, program, pids)
  end
  def intcode(operator, indexes=%{ :index => index }, program, pids) do
   [opcode, first, second, dest] = decompose(operator, indexes, program)
    value = operation(opcode, first, second)
    new_program = update_program(value, dest, program)
    new_indexes = %{indexes | index: index + 4}
    back(new_indexes, new_program, pids)
  end

  def back(indexes, program, pids) do
    intcode(Enum.at(program, indexes[:index]), indexes, program, pids)
  end

  def display(prev \\ []) do
    start_time = :os.system_time(:millisecond)
    IO.puts("display")
    receive do
      {:input, value} ->
        IO.puts("received #{value} in #{:os.system_time(:millisecond)- start_time}ms")
        display([value | prev])
      {:value, value} ->
        IO.puts("Intcode ended : #{value}")
    after 100000 ->
        IO.puts("stop display")
    end
  end

  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

end
