defmodule SecureTest do
  use ExUnit.Case, async: true
  doctest Secure

  describe "secure" do

    test "number" do
      assert [0,1,2,3,4,5,6,10] == Secure.number("123456")
    end

    test "valid number" do
      assert 0 == Secure.valid("123456")
      assert 0 == Secure.valid("111111")
      assert 0 == Secure.valid("223450")
      assert 0 == Secure.valid("123789")
      assert 1 == Secure.valid("112233")
      assert 0 == Secure.valid("123444")
      assert 1 == Secure.valid("111122")
    end

    test "valid_password" do
      assert 2 == Secure.valid_password("111120-111140")
    end
  end
end
#s 156218-652527
