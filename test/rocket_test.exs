defmodule RocketTest do
  use ExUnit.Case, async: true
  doctest Rocket

  describe "full consumption" do

    test "base consumption" do
      assert 2 == Rocket.base_full(12)
      assert 654 == Rocket.base_full(1969)
    end

    test "global consumption" do
      assert 966 == Rocket.global_full(1969)
    end

    test "operation" do
      assert 2 == Rocket.operation(1,1,1)
      assert 1 == Rocket.operation(2,1,1)
    end

    test "intcode with a one operation" do
      assert "2,0,0,0,99" == Rocket.intcode("1,0,0,0,99")
      assert "2,3,0,6,99" = Rocket.intcode("2,3,0,3,99")
      assert "2,4,4,5,99,9801" == Rocket.intcode("2,4,4,5,99,0")
      assert "30,1,1,4,2,5,6,0,99" == Rocket.intcode("1,1,1,4,99,5,6,0,99")
    end

    test "intcode with mode" do
      assert "1002,4,3,4,99" == Rocket.intcode("1002,4,3,4,33")
      assert "1101,100,-1,4,99" == Rocket.intcode("1101,100,-1,4,0")
    end

    test "more mode" do,

    end

    test "alarm_1202" do
      assert 2782414 == Rocket.alarm_1202
    end

    test "noun verb" do
      assert 1202 == Rocket.noun_verb(2782414)
    end

    test "line" do
      assert [[1,0],[2,0],[3,0]] == Rocket.line([0,0], "R3")
      assert [[-1,0],[-2,0],[-3,0]] == Rocket.line([0,0], "L3")
      assert [[0,0],[0,1],[0,0]] == Rocket.points(["U1","D1"])
    end

    test "manhattan distance" do
      assert 6 = Rocket.closest_wire("R8,U5,L5,D3\nU7,R6,D4,L4")
      assert 159 == Rocket.closest_wire("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
      assert 135 == Rocket.closest_wire("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
      assert 30 == Rocket.lower_step("R8,U5,L5,D3\nU7,R6,D4,L4")
      assert 610 == Rocket.lower_step("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
      assert 410 == Rocket.lower_step("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
    end
  end
end
