defmodule Day11Test do
  use ExUnit.Case, async: true
  doctest Day12

  describe "day 12 - part1" do
    test "velocity" do
      start = [{{-1,0,2},{0,0,0}},
      {{2,-10,-7},{0,0,0}},
      {{4,-8,8},{0,0,0}},
      {{3,5,-1},{0,0,0}}]
      expected = [{{2,-1, 1},{3,-1,-1}},
      {{3,-7,-4},{1, 3, 3}},
      {{1,-7, 5},{-3, 1,-3}},
      {{2, 2, 0},{-1,-3, 1}}]
      assert expected == Day12.step(start)
      assert expected == Day12.step(start, 1)
      step2 = [{{5,-3,-1},{ 3,-2,-2}},
      {{1,-2, 2},{-2, 5, 6}},
      {{1,-4,-1},{ 0, 3,-6}},
      {{1,-4, 2},{-1,-6, 2}}]
      assert step2 == Day12.step(expected)

      expected_10 = [{{2, 1,-3},{-3,-2, 1}},
      {{1,-8, 0},{-1, 1, 3}},
      {{3,-6, 1},{ 3, 2,-3}},
      {{2, 0, 4},{ 1,-1,-1}}]
      assert expected_10 == Day12.step(start, 10)
    end

    test 'energy' do
      start = [{-1,0,2},{2,-10,-7},{4,-8,8},{3,5,-1}]
      assert 179 == Day12.energy(start, 10)
      assert 1940 = Day12.energy([{-8,-10, 0}, {5, 5, 10}, {2, -7, 3}, {9, -8, -3}], 100)
      assert 9441 = Day12.energy([{17, -7, -11},{1, 4, -1},{6, -2, -6},{19, 11, 9}],1000)
    end
  end

  describe "day12 - part 2" do
    assert 18 == Day12.origin([{-1,0}, {2,0}, {4,0}, {3, 0}])
    assert 28 == Day12.origin([{0,0}, {-10,0}, {-8,0}, {5, 0}])
    assert 44 == Day12.origin([{2,0}, {-7,0}, {8,0}, {-1, 0}])
    assert 2772 == Day12.repeat([{-1,0,2},{2,-10,-7},{4,-8,8},{3,5,-1}])
    assert 4686774924 = Day12.repeat([{-8,-10, 0}, {5, 5, 10}, {2, -7, 3}, {9, -8, -3}])
    assert 4 = Day12.repeat([{17, -7, -11},{1, 4, -1},{6, -2, -6},{19, 11, 9}])

  end
end

# puzzle [{17, -7, -11}{1, 4, -1},{6, -2, -6},{19, 11, 9}]
