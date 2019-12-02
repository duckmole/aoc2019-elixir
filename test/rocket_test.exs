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
      assert 2 == Rocket.operation(1,0,0,[1,0,0,0,99])
      assert 1 == Rocket.operation(2,0,0,[1,0,0,0,99])
    end

    test "intcode with a one operation" do
      assert "2,0,0,0,99" == Rocket.intcode("1,0,0,0,99")
      assert "2,3,0,6,99" = Rocket.intcode("2,3,0,3,99")
      assert "2,4,4,5,99,9801" == Rocket.intcode("2,4,4,5,99,0")
      assert "30,1,1,4,2,5,6,0,99" == Rocket.intcode("1,1,1,4,99,5,6,0,99")
    end
  end
end
