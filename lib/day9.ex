defmodule Day9 do

  def boost(string, input) do
    {:ok, display_pid} = Task.start_link (fn -> Day9.display() end)
    pid = spawn(fn -> Day9.intcode(string, display_pid, display_pid) end)
    send(pid, {:output, input})
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

  def intcode(code, nil, thrusters_pid) do
    receive do
      {:pid, pid} -> intcode(code, pid, thrusters_pid)
    end
  end
  def intcode(code, child_pid, thrusters_pid) do
    decode = Enum.map(String.split(code, ","), fn(l) -> integer(l) end)
    intcode(List.first(decode), %{index: 0, relative_base: 0}, decode, %{child: child_pid, thrusters: thrusters_pid})
  end

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
      {:output, input} ->
        new_program = update_program(input, dest, program)
        new_indexes = %{indexes | index: index + 2}
        back(new_indexes, new_program, pids)
    end
  end
  def intcode(operator, indexes=%{ :index => index }, program, pids) when rem(operator,100) == 4 do
    first = decompose_first(operator, indexes, program)
    send(pids[:child], {:output, first})
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
      {:output, value} ->
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
