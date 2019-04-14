defmodule DistanceComparison do
  @moduledoc """

  This is a project made to compare distances between an origin and multiple
  destinations or multiple origins and a single destination (1:n or n:1)
  using the google distance matrix API.

  """

  @url "https://maps.googleapis.com/maps/api/distancematrix/json?"

  @doc """
  Sends the request to the google distance matrix API to return the distances
  from the origin(s) to the destination(s)

  (Still untested, due to not having an API key)
  """
  def send(%Paths{} = paths, options \\ %{}) do
    HTTPoison.start()

    {:ok, resp} = HTTPoison.get(@url <> params(paths, options))
    Poison.decode!(resp.body)
  end

  defp params(%Paths{} = paths, options) do
    %{key: Application.get_env(:distance_comparison, :api_key)}
    |> Map.merge(Paths.to_params(paths))
    |> Map.merge(options)
    |> URI.encode_query()
  end
end
