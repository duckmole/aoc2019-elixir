defmodule Day9 do

  def optimize_ampli(code) do
    perm = permutations([0, 1, 2, 3, 4])
    thrusters_pid = spawn(fn -> thrusters([], length(perm)) end)
    for phases <- perm do
      amplification_circuit(code, thrusters_pid, phases)
    end
  end

  def amplification_circuit(code, thrusters_pid, phases) do
    pid_a = start_amp(code, thrusters_pid, Enum.reverse(phases))
    send(pid_a, {:input, 0})
  end

  def start_amp(_, pid_a, []), do: pid_a
  def start_amp(code, child_pid, [phase | tail]) do
    pid = spawn(fn -> intcode(code, child_pid, child_pid) end)
    send pid, {:input, phase}
    start_amp(code, pid, tail)
  end

  def optimize_feedback(code) do
    perm = permutations([5, 6, 7, 8, 9])
    thrusters_pid = spawn(fn -> thrusters([], length(perm)) end)
    for phases <- perm do
      feedback_circuit(code, thrusters_pid, phases)
    end
  end

  def feedback_circuit(code, thrusters_pid, phases) do
    pids = [pid_a | _] = start_feedback(code, thrusters_pid, [], Enum.reverse(phases))
    Enum.map(Enum.zip(Enum.reverse(pids), Enum.reverse(phases)), fn ({pid, input}) ->
      send pid, {:input, input}
    end)
    send pid_a, {:input, 0}
  end

  def start_feedback(_, _, pids = [pid_a | tail], []) do
    send List.last(pids), {:pid, pid_a}
    pids
  end

  def start_feedback(code, thrusters_pid, [], [phase | tail]) do
    pid = spawn(fn -> intcode(code, nil, thrusters_pid) end)
    start_feedback(code, thrusters_pid, [pid], tail)
  end
  def start_feedback(code, thrusters_pid, pids = [child_pid | _], [phase | tail]) do
    pid = spawn(fn -> intcode(code, child_pid, nil) end)
    start_feedback(code, thrusters_pid, [pid | pids], tail)
  end


  def thrusters(values, max) when length(values) == max do
    IO.puts("MAX : #{Enum.max(values)}")
  end
  def thrusters(values, max) do
    receive do
      {:value, value} -> thrusters([value | values], max)
    end
  end

  def value(0, _, value, result), do: Enum.at(result, Enum.at(result, value))
  def value(1, _, index, result), do:  Enum.at(result, index)
  def value(2, indexes, value, result), do: Enum.at(result, value) + indexes[:relative_base]

  def compute_result(value, dest, result) do
    Enum.concat(Enum.concat(Enum.take(result, dest), [value]),
      Enum.take(result, dest + 1 - length(result)))
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

    IO.puts("#{opcode} - #{c} - #{b} - #{a} - #{index}")
    IO.puts("first #{c} - #{index+1}")
    first = value(c, indexes, index + 1, result)
    second = value(b, indexes, index + 2, result)
    dest = value(rem((a+1), 2), indexes, index + 3, result)
    IO.puts("values : #{first} - #{second} - #{dest}")
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
    intcode(List.first(decode), %{index: 0, relative_base: 0}, decode,
      %{child: child_pid, thrusters: thrusters_pid}, 0)
  end

  def intcode(99, _, result, pids, last_output) do
    case pids[:thrusters] do
      nil -> :ok
      pid -> send pid, {:value, last_output}
    end
    Enum.join(result, ",")
  end
  def intcode(operator, indexes, result, pids, last_output) when rem(operator,100) == 3 do
    dest = value(1, indexes, indexes[:index]+1, result)
    IO.puts("waiting")
    receive do
      {:input, input} ->
        new_result = compute_result(input, dest, result)
        intcode(Enum.at(new_result, indexes[:index] + 2), %{indexes | index: indexes[:index] + 2},
        new_result, pids, last_output)
    end
  end
  def intcode(operator, indexes, result, pids, _) when rem(operator,100) == 4 do
    value = value(1, indexes, indexes[:index]+1, result)
    index = indexes[:index]
    send pids[:child], {:input, value +  indexes[:relative_base]}
    intcode(Enum.at(result, indexes[:index] + 2),  %{indexes | index: indexes[:index] + 2},
      result, pids, value)
  end

  def intcode(operator, indexes, result, pids, last_output) when rem(operator,100) == 5 or rem(operator,100) == 6 do
    [opcode, first, second, _] = decompose(operator, indexes, result)
    new_indexes = %{indexes | index: jump(opcode, first, second, indexes[:inputs])}
    intcode(Enum.at(result, new_indexes[:index]), new_indexes, result, pids, last_output)
  end

  def intcode(operator, indexes, result, pids, last_output) when rem(operator,100) == 9 do
    [opcode, first, _, _] = decompose(operator, indexes, result)
    new_indexes = %{relative_base: indexes[:relative_base] + first,
                   index: indexes[:index] + 2}
    intcode(Enum.at(result, new_indexes[:index]), new_indexes, result, pids, last_output)
  end

  def intcode(operator, indexes, result, pids, last_output) do
    IO.puts("index #{indexes[:index]}")
    [opcode, first, second, dest] = decompose(operator, indexes, result)
    value = operation(opcode, first, second)
    new_result = compute_result(value, dest, result)
    intcode(Enum.at(new_result, indexes[:index] + 4), %{indexes | index: indexes[:index] + 4},
      new_result, pids, last_output)
  end

  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]
end
