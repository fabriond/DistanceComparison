defmodule Compare do

  require Logger

  @doc """
  Returns a map containing the best routes based on the map that returns from
  the google distance matrix API
  """
  def check_distance(%{status: "OK", origin_addresses: origins, destination_addresses: destinations, rows: rows}) do
    res = update_origin(origins, destinations, rows)

    hd Enum.sort(res, fn(%{distance: d1}, %{distance: d2}) -> d1 < d2 end)
  end

  def check_distance(%{status: status}) do
    raise RuntimeError, status <> " distance matrix response status, please " <>
    "check https://developers.google.com/maps/documentation/distance-matrix/intro#StatusCodes"
  end

# Gets the best destination for all origins using the update_destination/3
# function below
  defp update_origin(origins, destinations, rows, result \\ [])

  defp update_origin([], _destinations, [], result) do
    result
  end

  defp update_origin(origins, destinations, rows, result) do
    [current_row | rows] = rows
    [current_origin | origins] = origins
    %{elements: elements} = current_row

    result = [update_destination(current_origin, destinations, elements) | result]
    update_origin(origins, destinations, rows, result)
  end

# Gets the best destination for an origin based on the destinations list and the
# distance in the elements list (which comes from the google distance matrix API)
  defp update_destination(current_origin, destinations, elements, result \\ %{})

  defp update_destination(_current_origin, [], [], result)do
    result
  end

  defp update_destination(current_origin, destinations, elements, result) do
    [current_element | elements] = elements
    [current_destination | destinations] = destinations

    current_distance =
    if match?(%{status: "OK"}, current_element) do
      current_element.distance.value
    else
      Logger.error("element status: " <> current_element.status <> ", path " <>
                   "\"#{current_origin}\" -> \"#{current_destination}\" " <>
                   "will be discarded from the calculations")
      :invalid
    end

    result =
    if Map.has_key?(result, :distance) do
      old_distance = result.distance
      if current_distance != :invalid and current_distance < old_distance do
        %{origin: current_origin, destination: current_destination, distance: current_distance}
      else
        result
      end
    else
      %{origin: current_origin, destination: current_destination, distance: current_distance}
    end

    update_destination(current_origin, destinations, elements, result)
  end
end
