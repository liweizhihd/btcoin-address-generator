defmodule BAGTest do
  use ExUnit.Case
  doctest BAG

  test "greets the world" do
    assert BAG.hello() == :world
  end
end
