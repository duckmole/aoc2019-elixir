defmodule Day9 do

  def run(input) do
    {:ok, display_pid} = Task.start_link (fn -> Day9.display() end)
    pid = spawn(fn -> Day9.intcode("1102,34463338,34463338,63,1007,63,34463338,63,1005,63,53,1102,3,1,1000,109,988,209,12,9,1000,209,6,209,3,1008,1000,1,63,1005,63,65,1008,1000,2,63,1005,63,904,1008,1000,0,63,1005,63,58,4,25,104,0,99,4,0,104,0,99,4,17,104,0,99,0,0,1101,0,33,1017,1101,24,0,1014,1101,519,0,1028,1102,34,1,1004,1101,0,31,1007,1101,0,844,1025,1102,0,1,1020,1102,38,1,1003,1102,39,1,1008,1102,849,1,1024,1101,0,22,1001,1102,25,1,1009,1101,1,0,1021,1101,0,407,1022,1101,404,0,1023,1101,0,35,1013,1101,27,0,1011,1101,0,37,1016,1102,1,26,1019,1102,28,1,1015,1101,0,30,1000,1102,1,36,1005,1101,0,29,1002,1101,23,0,1012,1102,1,32,1010,1102,21,1,1006,1101,808,0,1027,1102,20,1,1018,1101,0,514,1029,1102,1,815,1026,109,14,2107,24,-5,63,1005,63,199,4,187,1105,1,203,1001,64,1,64,1002,64,2,64,109,-1,2108,21,-7,63,1005,63,225,4,209,1001,64,1,64,1106,0,225,1002,64,2,64,109,-16,1201,6,0,63,1008,63,35,63,1005,63,249,1001,64,1,64,1106,0,251,4,231,1002,64,2,64,109,9,2102,1,2,63,1008,63,37,63,1005,63,271,1105,1,277,4,257,1001,64,1,64,1002,64,2,64,109,11,1208,-8,23,63,1005,63,293,1105,1,299,4,283,1001,64,1,64,1002,64,2,64,109,8,21107,40,39,-8,1005,1017,319,1001,64,1,64,1106,0,321,4,305,1002,64,2,64,109,-28,2101,0,6,63,1008,63,39,63,1005,63,341,1106,0,347,4,327,1001,64,1,64,1002,64,2,64,109,19,2107,26,-7,63,1005,63,363,1106,0,369,4,353,1001,64,1,64,1002,64,2,64,109,1,1202,-9,1,63,1008,63,39,63,1005,63,395,4,375,1001,64,1,64,1105,1,395,1002,64,2,64,109,9,2105,1,-3,1106,0,413,4,401,1001,64,1,64,1002,64,2,64,109,-13,1207,-4,26,63,1005,63,435,4,419,1001,64,1,64,1105,1,435,1002,64,2,64,109,-1,21101,41,0,7,1008,1019,41,63,1005,63,461,4,441,1001,64,1,64,1105,1,461,1002,64,2,64,109,7,21107,42,43,-2,1005,1017,479,4,467,1105,1,483,1001,64,1,64,1002,64,2,64,109,-6,21108,43,46,0,1005,1013,499,1106,0,505,4,489,1001,64,1,64,1002,64,2,64,109,17,2106,0,-2,4,511,1105,1,523,1001,64,1,64,1002,64,2,64,109,-27,1202,-1,1,63,1008,63,28,63,1005,63,547,1001,64,1,64,1106,0,549,4,529,1002,64,2,64,109,18,1206,-1,567,4,555,1001,64,1,64,1106,0,567,1002,64,2,64,109,-16,21102,44,1,6,1008,1011,43,63,1005,63,587,1106,0,593,4,573,1001,64,1,64,1002,64,2,64,109,8,21102,45,1,-1,1008,1012,45,63,1005,63,619,4,599,1001,64,1,64,1105,1,619,1002,64,2,64,109,7,1205,1,633,4,625,1106,0,637,1001,64,1,64,1002,64,2,64,109,-8,2102,1,-3,63,1008,63,25,63,1005,63,659,4,643,1105,1,663,1001,64,1,64,1002,64,2,64,109,14,1206,-5,679,1001,64,1,64,1105,1,681,4,669,1002,64,2,64,109,-28,2101,0,2,63,1008,63,30,63,1005,63,707,4,687,1001,64,1,64,1106,0,707,1002,64,2,64,109,21,21101,46,0,0,1008,1019,48,63,1005,63,727,1106,0,733,4,713,1001,64,1,64,1002,64,2,64,109,-3,21108,47,47,1,1005,1017,751,4,739,1106,0,755,1001,64,1,64,1002,64,2,64,109,-13,1207,0,37,63,1005,63,771,1105,1,777,4,761,1001,64,1,64,1002,64,2,64,109,7,2108,21,-9,63,1005,63,797,1001,64,1,64,1105,1,799,4,783,1002,64,2,64,109,22,2106,0,-5,1001,64,1,64,1106,0,817,4,805,1002,64,2,64,109,-4,1205,-8,829,1106,0,835,4,823,1001,64,1,64,1002,64,2,64,109,-4,2105,1,0,4,841,1105,1,853,1001,64,1,64,1002,64,2,64,109,-30,1208,6,30,63,1005,63,871,4,859,1105,1,875,1001,64,1,64,1002,64,2,64,109,-2,1201,9,0,63,1008,63,22,63,1005,63,897,4,881,1106,0,901,1001,64,1,64,4,64,99,21101,27,0,1,21102,1,915,0,1106,0,922,21201,1,66266,1,204,1,99,109,3,1207,-2,3,63,1005,63,964,21201,-2,-1,1,21102,942,1,0,1105,1,922,22101,0,1,-1,21201,-2,-3,1,21101,0,957,0,1106,0,922,22201,1,-1,-2,1105,1,968,21202,-2,1,-2,109,-3,2106,0,0", display_pid, display_pid) end)
    send(pid, {:output, input})
  end

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

  def value(0, indexes, value, result), do: Enum.at(result, Enum.at(result, value))
  def value(1, indexes, value, result), do: Enum.at(result, value)
  def value(2, indexes, value, result), do: Enum.at(result, Enum.at(result, value) + indexes[:relative_base])

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

    first = value(c, indexes, index + 1, result) || 0
    second = value(b, indexes, index + 2, result) || 0
    dest = value(rem((a+1), 2), indexes, index + 3, result) || 0
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

  def intcode(99, indexes, result, pids, last_output) do
    log(99, indexes, result)
    case pids[:thrusters] do
      nil -> :ok
      pid -> send pid, {:value, last_output}
    end
    Enum.join(result, ",")
  end
  def intcode(operator, indexes, result, pids, last_output) when rem(operator,100) == 3 do
    log(operator, indexes, result)
    dest = value(1, indexes, indexes[:index]+1, result)
    receive do
      {:output, input} ->
        new_result = compute_result(input, dest, result)
        intcode(Enum.at(new_result, indexes[:index] + 2), %{indexes | index: indexes[:index] + 2},
        new_result, pids, last_output)
    end
  end
  def intcode(operator, indexes, result, pids, _) when rem(operator,100) == 4 do
    log(operator, indexes, result)
    string = Enum.join(result,",")
    [opcode, first, second, dest] = decompose(operator, indexes, result)
    send pids[:child], {:output, first}
    intcode(Enum.at(result, indexes[:index] + 2),  %{indexes | index: indexes[:index] + 2},
      result, pids, first)
  end

  def intcode(operator, indexes, result, pids, last_output) when rem(operator,100) == 5 or rem(operator,100) == 6 do
    log(operator, indexes, result)
    [opcode, first, second, _] = decompose(operator, indexes, result)
    new_indexes = %{indexes | index: jump(opcode, first, second, indexes[:index])}
    intcode(Enum.at(result, new_indexes[:index]), new_indexes, result, pids, last_output)
  end

  def intcode(operator, indexes, result, pids, last_output) when rem(operator,100) == 9 do
    log(operator, indexes, result)
    [opcode, first, _, _] = decompose(operator, indexes, result)
    new_indexes = %{relative_base: indexes[:relative_base] + first,
                   index: indexes[:index] + 2}
    intcode(Enum.at(result, new_indexes[:index]), new_indexes, result, pids, last_output)
  end

  def intcode(operator, indexes, result, pids, last_output) do
    log(operator, indexes, result)
    [opcode, first, second, dest] = decompose(operator, indexes, result)
    value = operation(opcode, first, second)
    new_result = compute_result(value, dest, result)
    intcode(Enum.at(new_result, indexes[:index] + 4), %{indexes | index: indexes[:index] + 4},
      new_result, pids, last_output)
  end

  def log(operator, indexes, result) do
    string = Enum.join(result,",")
    #IO.puts("op #{operator} i - #{indexes[:index]} ------ #{string}")
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
