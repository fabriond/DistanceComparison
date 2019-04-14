defmodule PathsTest do
  use ExUnit.Case
  doctest Paths

  test "create paths map with one origin" do
    assert Paths.new("Paris", ["Lyon", "Marseille"])
  end

  test "create paths map with one destination" do
    assert Paths.new(["Lyon", "Marseille"], "Paris")
  end

  test "create paths map with multiple origins and destinations" do
    assert_raise ArgumentError, "Both arguments cannot be lists", fn ->
      Paths.new(["Lyon", "Marseille"], ["Paris", "Chantilly"])
    end
  end

  test "add destination to destinations list" do
    assert(Paths.new("Paris", ["Lyon", "Marseille"]) |> Paths.add("Chantilly"))
  end

  test "add origin to origins list" do
    assert(Paths.new(["Lyon", "Marseille"], "Paris") |> Paths.add("Chantilly"))
  end

  test "add destinations to destinations list" do
    assert(Paths.new("Paris", ["Lyon", "Marseille"]) |> Paths.add(["Nantes", "Chantilly"]))
  end

  test "add origins to origins list" do
    assert(Paths.new(["Lyon", "Marseille"], "Paris") |> Paths.add(["Nantes", "Chantilly"]))
  end

  test "get params map" do
    assert(Paths.new("Paris", ["Lyon", "Marseille"]) |> Paths.to_params())
  end
end
