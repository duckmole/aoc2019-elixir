defmodule Day6Test do
  use ExUnit.Case, async: true
  doctest Day6

  describe "part1" do
    test "line" do
#      assert 5 == Day6.nb_orbits("COM)B\nB)C\nB)G")
#      assert 42 == Day6.nb_orbits("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L")
    end

    test "do orbits" do
#      %{"B" => {"COM", 0}, "C" => {"B", 0}, "G" => {"B", 0}} = Day6.do_orbits(["COM)B","B)C","B)G"], :part1)
    end
  end

  describe "part2" do
    test "san to you" do
      assert 4 = Day6.to_santa("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN")
    end

    test "way" do
      assert ["COM", "B", "C", "D", "I", "SAN"] == Day6.way("COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN", "SAN")
    end
  end
end
