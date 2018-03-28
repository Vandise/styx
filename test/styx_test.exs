defmodule StyxTest do
  use ExUnit.Case
  doctest Styx

  test "greets the world" do
    assert Styx.hello() == :world
  end
end
