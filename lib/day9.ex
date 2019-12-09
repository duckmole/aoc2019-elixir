defmodule Day9 do

  def run(path) do
    path |> File.read! |> boost(1)
  end

  def boost(input, string) do
    {:ok, display_pid} = Task.start_link (fn -> Day9.display() end)
    pid = spawn(fn -> Day9.intcode(string, display_pid, display_pid) end)
    send(pid, {:output, input})
  end

  def value(opcode, indexes, index, result), do: Enum.at(result, destination(opcode, indexes, index, result)) || 0

  def destination(0, _, index, result), do: Enum.at(result, index) || 0
  def destination(1, _, index, result), do: index
  def destination(2, indexes, index, result), do: (Enum.at(result, index) || 0) + indexes[:relative_base]

  def compute_result(value, dest, result) do
    max_heap = length(result)
    case dest <= max_heap do
      true ->
        Enum.concat(Enum.concat(Enum.take(result, dest), [value]),
          Enum.take(result, dest + 1 - max_heap))
      _ ->
        Enum.concat(Enum.concat(result, List.duplicate(0, dest - max_heap )),[value])
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

  def decompose(operator, indexes, result) do
    opcode = rem(operator, 100)
    c =  div(rem(operator, 1000),100)
    b = div(rem(operator, 10000),1000)
    a = div(operator, 100000)
    index = indexes[:index]

    first = value(c, indexes, index + 1, result)
    second = value(b, indexes, index + 2, result)
    dest = destination(a, indexes, index + 3, result)
    [opcode, first, second, dest]
  end

  def jump(5, 0, _, index), do: index + 3
  def jump(5, _, second, _), do: second
  def jump(6, 0, second, _), do: second
  def jump(6, _, _, index), do: index + 3

  def intcode(code, nil, thrusters_pid) do
    receive do
      {:pid, pid} -> intcode(code, pid, thrusters_pid)
    end
  end
  def intcode(code, child_pid, thrusters_pid) do
    decode = Enum.map(String.split(code, ","), fn(l) -> integer(l) end)
    intcode(List.first(decode), %{index: 0, relative_base: 0}, decode, %{child: child_pid, thrusters: thrusters_pid})
  end

  def intcode(99, indexes, result, pids) do
    case pids[:thrusters] do
      nil -> :ok
      pid -> send pid, {:state, :stop}
    end
    Enum.join(result, ",")
  end

  def intcode(operator, indexes, result, pids) when rem(operator,100) == 3 do
    c =  div(rem(operator, 1000),100)
    dest = destination(c, indexes, indexes[:index]+1, result)
    receive do
      {:output, input} ->
        new_result = compute_result(input, dest, result)
        intcode(Enum.at(new_result, indexes[:index] + 2), %{indexes | index: indexes[:index] + 2}, new_result, pids)
    end
  end
  def intcode(operator, indexes, result, pids) when rem(operator,100) == 4 do
    [opcode, first, second, dest] = decompose(operator, indexes, result)
    send(pids[:child], {:output, first})
    intcode(Enum.at(result, indexes[:index] + 2),  %{indexes | index: indexes[:index] + 2}, result, pids)
  end
  def intcode(operator, indexes, result, pids) when rem(operator,100) == 5 or rem(operator,100) == 6 do
    [opcode, first, second, _] = decompose(operator, indexes, result)
    new_indexes = %{indexes | index: jump(opcode, first, second, indexes[:index])}
    intcode(Enum.at(result, new_indexes[:index]), new_indexes, result, pids)
  end
  def intcode(operator, indexes, result, pids) when rem(operator,100) == 9 do
    [_opcode, first, _, _] = decompose(operator, indexes, result)
    new_indexes = %{relative_base: indexes[:relative_base] + first, index: indexes[:index] + 2}
    intcode(Enum.at(result, new_indexes[:index]), new_indexes, result, pids)
  end
  def intcode(operator, indexes, result, pids) do
    [opcode, first, second, dest] = decompose(operator, indexes, result)
    value = operation(opcode, first, second)
    new_result = compute_result(value, dest, result)
    intcode(Enum.at(new_result, indexes[:index] + 4), %{indexes | index: indexes[:index] + 4}, new_result, pids)
  end

  def display(prev \\ []) do
    receive do
      {:output, value} ->
        IO.puts("received #{value}")
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
