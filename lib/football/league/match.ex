defmodule Football.League.Match do
  use Ecto.Schema
  import Ecto.Changeset

  @match_result_types ~w(H D A) # H=Home Win, D=Draw, A=Away Win)

  schema "matches" do
    field :division, :string
    field :season, :string

    field :match_date, :date
    field :home_team, :string
    field :away_team, :string

    field :fthg, :integer # Full Time Home Team Goals
    field :ftag, :integer # Full Time Away Team Goals
    field :ftr, :string   # Full Time Result

    field :hthg, :integer # Half Time Home Team Goals
    field :htag, :integer # Half Time Away Team Goals
    field :htr, :string   # Half Time Result
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:division, :season, :match_date, :home_team, :away_team, :fthg, :ftag, :ftr, :hthg, :htag, :htr])
    |> validate_required([:division, :season, :match_date, :home_team, :away_team, :fthg, :ftag, :ftr, :hthg, :htag, :htr])
    |> validate_inclusion(:ftr, @match_result_types)
    |> validate_inclusion(:htr, @match_result_types)
  end
end
