defmodule DistanceComparisonTest do
  use ExUnit.Case
  doctest DistanceComparison

  @input_map1 %{status: "OK", origin_addresses: ["Vancouver, BC, Canada"], destination_addresses: ["San Francisco, California, United States", "Victoria, BC, Canada"],
                rows: [%{elements: [%{status: "OK", distance: %{value: 1734542, text: "1735km"}}, %{status: "OK", distance: %{value: 129324, text: "129km"}}]}]}

  @expected_output1 %{destination: "Victoria, BC, Canada", distance: 129324, origin: "Vancouver, BC, Canada"}

  @input_map2 %{status: "OK", origin_addresses: ["San Francisco, California, United States", "Victoria, BC, Canada"], destination_addresses: ["Vancouver, BC, Canada"],
                rows: [%{elements: [%{status: "OK", distance: %{value: 1734542, text: "1735km"}}]}, %{elements: [%{status: "OK", distance: %{value: 129324, text: "129km"}}]}]}

  @expected_output2 %{destination: "Vancouver, BC, Canada", distance: 129324, origin: "Victoria, BC, Canada"}

  test "check_distance test for a single origin" do
    assert DistanceComparison.check_distance(@input_map1) == @expected_output1
  end

  test "check_distance test for a single destination" do
    assert DistanceComparison.check_distance(@input_map2) == @expected_output2
  end

end
