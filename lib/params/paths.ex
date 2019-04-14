defmodule Paths do

  defstruct [:origin, :destination]

  @type one_origin :: %__MODULE__{origin: String.t, destination: List.t}
  @type one_dest :: %__MODULE__{origin: List.t, destination: String.t}

  @sep "|"

  @doc """
  Creates a new group of paths, receives origin(s) and destination(s), one of
  them needs to be a String, representing a location, and the other a List of
  Strings, each representing a location

  The string representing a location can be a name or it can be
  "latitude,longitude" (notice there's no space)

  ## Example

      iex> Paths.new("Paris", ["Marseille", "Lyon"])
      %Paths{destination: ["Marseille", "Lyon"], origin: "Paris"}

  """

  def new(origins \\ [], destinations \\ []) when not is_nil(origins) and not is_nil(destinations) do
    if not(is_list(origins) and is_list(destinations)) do
      %__MODULE__{origin: origins, destination: destinations}
    else
      raise ArgumentError, "Both arguments cannot be lists"
    end
  end

  def add(prev_paths, orgs_or_dests \\ [])

  def add(prev_paths, org_or_dest) when not is_list(org_or_dest) do
    add(prev_paths, [org_or_dest])
  end

  @doc """
  Adds a list of destinations to the Paths map destination list, only usable if origin
  is not a list.

  The string representing each destination can be a name or it can be
  "latitude,longitude" (notice there's no space)

  ## Example

      iex> paths = Paths.new("Paris", ["Marseille", "Lyon"])
      %Paths{destination: ["Marseille", "Lyon"], origin: "Paris"}
      iex> Paths.add(paths, ["Chantilly", "Nantes"])
      %Paths{
        destination: ["Marseille", "Lyon", "Chantilly", "Nantes"],
        origin: "Paris"
      }

  """
  def add(%__MODULE__{origin: org, destination: dest}, destinations) when is_list(destinations) and not is_list(org) do
    %__MODULE__{origin: org, destination: concat(dest, destinations)}
  end

  @doc """
  Adds a list of origins to the Paths map origin list, only usable if
  destination is not a list.

  The string representing each origin can be a name or it can be
  "latitude,longitude" (notice there's no space)

  ## Example

      iex> paths = Paths.new(["Marseille", "Lyon"], "Paris")
      %Paths{destination: "Paris", origin: ["Marseille", "Lyon"]}
      iex> Paths.add(paths, ["Chantilly", "Nantes"])
      %Paths{
        destination: "Paris",
        origin: ["Marseille", "Lyon", "Chantilly", "Nantes"]
      }

  """
  def add(%__MODULE__{origin: org, destination: dest}, origins) when is_list(origins) and not is_list(dest) do
    %__MODULE__{origin: concat(org, origins), destination: dest}
  end

  @doc """
  Gets the params map to add to the url with the origin(s) and destination(s)
  contained in the Paths map

  ## Example

    iex> paths1 = Paths.new(["Marseille", "Lyon"], "Paris")
    %Paths{destination: "Paris", origin: ["Marseille", "Lyon"]}
    iex> Paths.to_params(paths1)
    %{destinations: "Paris", origins: "Marseille|Lyon"}

    iex> paths2 = Paths.new("Paris", ["Marseille", "Lyon"])
    %Paths{destination: ["Marseille", "Lyon"], origin: "Paris"}
    iex> Paths.to_params(paths2)
    %{destinations: "Marseille|Lyon", origins: "Paris"}

  """
  def to_params(%__MODULE__{} = paths) do
    cond do
      is_list(paths.origin) ->
        %{origins: Enum.join(paths.origin, @sep), destinations: paths.destination}
      is_list(paths.destination) ->
        %{origins: paths.origin, destinations: Enum.join(paths.destination, @sep)}
    end
  end

  defp concat(nil, b) when is_list(b) do
    concat([], b)
  end

  defp concat(a, b) when is_list(a) and is_list(b) do
    a++b
  end

end
