defmodule Football.League.Result do
  use Ecto.Schema

  @primary_key false
  schema "results" do
    field :division, :string
    field :season, :string

    field :played, :integer
    field :win, :integer
    field :lose, :integer

    field :goals_for, :integer
    field :goals_againts, :integer
    field :goals_diffs, :integer

    field :points, :integer
  end
end
