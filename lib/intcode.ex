defmodule Intcode do

  def optimize_ampli(code) do
    perm = permutations([0, 1, 2, 3, 4])
    pid_thrusters = spawn(fn -> thrusters([], length(perm)) end)
    for phases <- perm do
      amplification_circuit(code, pid_thrusters, phases)
    end
  end

  def amplification_circuit(code, pid_thrusters, phases) do
    pid_a = start_amp(code, pid_thrusters, Enum.reverse(phases))
    send pid_a, 0
  end

  def feedback_circuit(code, pid_thrusters, phases) do
#    start_feedback(code, nil, phases)
  end

  def start_amp(_, pid_a, []), do: pid_a
  def start_amp(code, child_pid, [phase | tail]) do
    pid = spawn(fn -> intcode(code, child_pid) end)
    send pid, phase
    start_amp(code, pid, tail)
  end

  def thrusters(values, max) when length(values) == max do
    IO.puts("MAX : #{Enum.max(values)}")
  end
  def thrusters(values, max) do
    receive do
      value -> thrusters([value | values], max)
    end
  end

  def value(0, value, result) do
    Enum.at(result, Enum.at(result, value))
  end
  def value(1, value, result) do
    Enum.at(result, value)
  end

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

  def decompose(operator, index, result) do
    opcode = rem(operator, 100)
    c =  div(rem(operator, 1000),100)
    b = div(rem(operator, 10000),1000)
    a = div(operator, 100000)

    first = value(c, index + 1, result)
    second = value(b, index + 2, result)
    dest = value(rem((a+1), 2), index + 3, result)
    [opcode, first, second, dest]
  end

  def jump(5, 0, _, index), do: index + 3
  def jump(5, _, second, _), do: second
  def jump(6, 0, second, _), do: second
  def jump(6, _, _, index), do: index + 3

  def intcode(code, child_pid) do
    decode = Enum.map(String.split(code, ","), fn(l) -> integer(l) end)
    intcode(List.first(decode), 0, decode, child_pid)
  end

  def intcode(99, _, result, child_pid) do
    Enum.join(result, ",")
  end
  def intcode(operator, index, result, child_pid) when rem(operator,100) == 3 do
    dest = value(1, index+1, result)
    receive do
      input -> new_result = compute_result(input, dest, result)
      intcode(Enum.at(new_result, index + 2), index + 2,
        new_result, child_pid)
    end
  end
  def intcode(operator, index, result, child_pid) when rem(operator,100) == 4 do
    value = value(0, index+1, result)
    send child_pid, value
    intcode(Enum.at(result, index + 2), index + 2,
      result, child_pid)
  end

  def intcode(operator, index, result, child_pid) when rem(operator,100) == 5 or rem(operator,100) == 6 do
    [opcode, first, second, _] = decompose(operator, index, result)
    new_index = jump(opcode, first, second, index)
    intcode(Enum.at(result, new_index), new_index, result, child_pid)
  end

  def intcode(operator, index, result, child_pid) do
    [opcode, first, second, dest] = decompose(operator, index, result)
    value = operation(opcode, first, second)
    new_result = compute_result(value, dest, result)
    intcode(Enum.at(new_result, index + 4), index + 4, new_result, child_pid)
  end

  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]

end
