defmodule Football.League do
  @moduledoc """
  The League context.
  """

  import Ecto.Query, warn: false
  alias Football.Repo

  alias Football.League.{Match, Result}

  @doc """
  Returns the list of results by division, season.
  """
  def list_results(division, season) do
    Result
    |> where(division: ^division, season: ^season)
    |> Repo.all()
  end

  @doc """
  Returns the list of matches by division, season.
  """
  def list_matches(division, season) do
    Match
    |> where(division: ^division, season: ^season)
    |> Repo.all()
  end
end
