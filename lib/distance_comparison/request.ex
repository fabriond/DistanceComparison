defmodule Request do

  @base_url "https://maps.googleapis.com/maps/api/distancematrix/json?"

  def get(%Paths{} = paths, options \\ %{}) do
    paths
    |> get_url(options)
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Poison.decode!()
  end

  defp get_url(%Paths{} = paths, options) do
    @base_url <> params(paths, options)
  end

  defp params(%Paths{} = paths, options) do
    %{key: Application.get_env(:distance_comparison, :api_key)}
    |> Map.merge(Paths.to_params(paths))
    |> Map.merge(options)
    |> URI.encode_query()
  end

end
