defmodule Day13 do

  def part1(path) do
    path |> File.read!() |> run()
  end

  def run(puzzle) do
    program = spawn(fn -> intcode(puzzle, nil, nil) end)
    display = spawn(fn -> loop(program) end)
    send(program, {:pid, display})
  end

  def loop(arcade, map \\ %{}, x \\ nil, y \\ nil, ball \\ nil, paddle \\ nil ) do
    receive do
      {:input, input} ->
        case x do
          nil -> loop(arcade, map, input, nil, ball, paddle)
          _ -> case y do
                 nil -> loop(arcade, map, x, input, ball, paddle)
                 _ ->
                   score(x,y, input)
                   block(map)
                   case input do
                     4 ->
                       case paddle do
                         {xp, _} ->
                           send(arcade, {:input, floor((x-xp)/abs(x-xp))})
                         _ ->
                           send(arcade, {:input, 0})
                           :no_paddle
                       end
                     loop(arcade, Map.put(map, {x,y}, input), nil, nil, {x,y}, paddle)
                     3 ->
                       loop(arcade, Map.put(map, {x,y}, input), nil, nil, ball, {x,y})
                       _ -> loop(arcade, Map.put(map, {x,y}, input), nil, nil, ball, paddle)
                   end
               end
        end
      unexpected -> IO.puts unexpected
    after 10000 ->
        IO.puts('to long')
        image(map)
    end
  end

  def score(-1, 0, score), do: IO.puts("score -> #{score}")
  def score(_,_,_), do: :ok

  def block(map) do
    nb_block = length(Enum.filter(map, fn({position, type}) -> type == 2 end))
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
                4 -> "O"
                3 -> "_"
                2 -> "#"
                1 -> "|"
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
      unexpected ->
        IO.puts("unexpected input #{unexpected}")
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
