defmodule Day8Test do
  use ExUnit.Case, async: true
  doctest Day8

  describe "part1" do
    test "part1" do
      assert 2 == Day8.part1(["", "1", "2", "2", "0"], 4)
      assert 2 == Day8.part1(["", "1", "2", "0", "0", "1", "2", "2", "0"], 4)
    end
  end
  describe "part2" do
    test "part1" do
      assert ["1", "1", "0", "0"] == Day8.part2(["", "1", "2", "2", "0", "0", "1", "0", "1"], 4)
    end
  end
end
