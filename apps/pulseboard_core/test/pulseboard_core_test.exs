defmodule PulseboardCoreTest do
  use ExUnit.Case
  doctest PulseboardCore

  test "greets the world" do
    assert PulseboardCore.hello() == :world
  end
end
