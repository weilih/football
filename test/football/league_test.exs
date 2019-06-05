defmodule Football.LeagueTest do
  use Football.DataCase

  alias Football.League

  describe "matches" do
    alias Football.League.Match

    @attrs %{away_team: "some away_team", division: "some division", ftag: 42, fthg: 42, ftr: "D", home_team: "some home_team", htag: 42, hthg: 42, htr: "D", match_date: ~D[2010-04-17], season: "some season"}

    def match_fixture(attrs \\ %{}) do
      Match
      |> struct(Enum.into(attrs, @attrs))
      |> Football.Repo.insert!()
    end

    test "list_matches/2 returns all matches" do
      match = match_fixture()
      assert League.list_matches("some division", "some season") == [match]
    end
  end
end
