defmodule IntcodeTest do
  use ExUnit.Case, async: true
  doctest Day10

  describe "day 10 - part1" do
    test "visible ateroid" do
      map = ".#..#\n.....\n#####\n....#\n...##\n"
      assert 7 == Day10.visible_asteroids(map, {1,0})
      assert 8 == Day10.visible_asteroids(map, {3,4})
      assert 7 == Day10.visible_asteroids(map, {1,2})
    end

    test "visibility" do
      map = ".#..#\n.....\n#####\n....#\n...##\n"
      assert {8, {3,4}} == Day10.visibility(map)
    end

    test "asteroids" do
      map = "#..\n..#\n"
      assert [{2,1},{0,0}] = Day10.asteroids(map)
    end

    test "visible" do
      origin = {0,0}
      visible = {3,1}
      not_visible = {6,2}
      asteroids =[{0,0},{3,1},{6,2}]
      assert true ==  Day10.visible(origin, visible, asteroids)
      assert false ==  Day10.visible(origin, not_visible, asteroids)
      map = ".#..#\n.....\n#####\n....#\n...##\n"
      assert true == Day10.visible({3,4}, {4,0}, Day10.asteroids(map))
      assert true == Day10.visible({3,4}, {4,4}, Day10.asteroids(map))
      assert true == Day10.visible({1,2}, {4,4}, Day10.asteroids(map))
    end
  end
  describe "day 10 - part2" do
    test "asteroids" do
      map = "##.\n.X#\n"
      assert {{1,1}, [{2,1},{1, 0},{0,0}]} = Day10.station_asteroids(map)
    end

    test "vectors" do
      map = "##.\n.X#\n"
      assert [{{1, 1000}, {1,0}}, {{-1, 0}, {0,-1}} ,{{-1, 1}, {-1, -1}}] = Day10.vectors(map)
    end
  end
end


 Day10.visibility(".#..#..##.#...###.#............#.\n.....#..........##..#..#####.#..#\n#....#...#..#.......#...........#\n.#....#....#....#.#...#.#.#.#....\n..#..#.....#.......###.#.#.##....\n...#.##.###..#....#........#..#.#\n..#.##..#.#.#...##..........#...#\n..#..#.......................#..#\n...#..#.#...##.#...#.#..#.#......\n......#......#.....#.............\n.###..#.#..#...#..#.#.......##..#\n.#...#.................###......#\n#.#.......#..####.#..##.###.....#\n.#.#..#.#...##.#.#..#..##.#.#.#..\n##...#....#...#....##....#.#....#\n......#..#......#.#.....##..#.#..\n##.###.....#.#.###.#..#..#..###..\n#...........#.#..#..#..#....#....\n..........#.#.#..#.###...#.....#.\n...#.###........##..#..##........\n.###.....#.#.###...##.........#..\n#.#...##.....#.#.........#..#.###\n..##..##........#........#......#\n..####......#...#..........#.#...\n......##...##.#........#...##.##.\n.#..###...#.......#........#....#\n...##...#..#...#..#..#.#.#...#...\n....#......#.#............##.....\n#......####...#.....#...#......#.\n...#............#...#..#.#.#..#.#\n.#...#....###.####....#.#........\n#.#...##...#.##...#....#.#..##.#.\n.#....#.###..#..##.#.##...#.#..##\n")
