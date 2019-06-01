defmodule Football.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :division, :string
      add :season, :string

      add :match_date, :date
      add :home_team, :string
      add :away_team, :string

      add :fthg, :integer
      add :ftag, :integer
      add :ftr, :string, size: 1

      add :hthg, :integer
      add :htag, :integer
      add :htr, :string, size: 1
    end
  end
end
