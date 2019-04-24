defmodule DistanceComparison do
  @moduledoc """

  This is a project made to compare distances between an origin and multiple
  destinations or multiple origins and a single destination (1:n or n:1)
  using the google distance matrix API.

  """

  @doc """
  Sends the request to the google distance matrix API to return the distances
  from the origin(s) to the destination(s)

  (Still untested, due to not having an API key)
  """
  def best_distance(%Paths{} = paths, options \\ %{}) do
    Request.get(paths, options)
    |> Compare.check_distance()
  end
end
