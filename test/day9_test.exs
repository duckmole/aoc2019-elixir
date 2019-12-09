defmodule IntcodeTest do
  use ExUnit.Case, async: true
  doctest Day9

  describe "day 9" do
    test "part 1" do
      check_part1([{:output, 1219070632396864},{:value, 1219070632396864}],"1102,34915192,34915192,7,4,7,99,0")
      check_part1([{:output, 1125899906842624},{:value, 1125899906842624}],  "104,1125899906842624,99")
      expected = [{:output, 109}, {:output, 1}, {:output, 204},
                  {:output, -1}, {:output, 1001}, {:output, 100},
                  {:output, 1}, {:output, 100}, {:output, 1008},
                  {:output, 100}, {:output, 16}, {:output, 101},
                  {:output, 1006}, {:output, 101}, {:output, 0}, {:output, 99},
                  {:value, 99}
                 ]
      input = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
      check_part1(expected, input)
    end
  end

  def receiver([], received) do
    receive do
      data -> assert false
    after 10000 -> assert true
    end
  end

  def receiver([current| tail], received) do
    receive do
      {type, value} -> IO.puts("received value #{type} - #{value}")
      assert current == {type, value}
      receiver(tail, [{type, value} | received])
    after 10000 -> assert false
    end
  end

  def check_part1(expected, code, received \\ []) do
    {:ok, pid} = Task.start_link (fn -> receiver(expected, []) end)
    Day9.intcode(code, pid, pid)
    :timer.sleep(1000)
  end
end
