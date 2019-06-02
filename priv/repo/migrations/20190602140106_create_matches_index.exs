defmodule Football.Repo.Migrations.CreateMatchesIndexes do
  use Ecto.Migration

  def change do
    create index(:matches, [:division, :season])
  end
end
