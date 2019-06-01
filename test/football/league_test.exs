defmodule Football.LeagueTest do
  use Football.DataCase

  alias Football.League

  describe "matches" do
    alias Football.League.Match

    @valid_attrs %{away_team: "some away_team", division: "some division", ftag: 42, fthg: 42, ftr: "D", home_team: "some home_team", htag: 42, hthg: 42, htr: "D", match_date: ~D[2010-04-17], season: "some season"}
    @update_attrs %{away_team: "some updated away_team", division: "some updated division", ftag: 43, fthg: 44, ftr: "H", home_team: "some updated home_team", htag: 43, hthg: 43, htr: "D", match_date: ~D[2011-05-18], season: "some updated season"}
    @invalid_attrs %{away_team: nil, division: nil, ftag: nil, fthg: nil, ftr: nil, home_team: nil, htag: nil, hthg: nil, htr: nil, match_date: nil, season: nil}

    def match_fixture(attrs \\ %{}) do
      {:ok, match} =
        attrs
        |> Enum.into(@valid_attrs)
        |> League.create_match()

      match
    end

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert League.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert League.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      assert {:ok, %Match{} = match} = League.create_match(@valid_attrs)
      assert match.away_team == "some away_team"
      assert match.division == "some division"
      assert match.ftag == 42
      assert match.fthg == 42
      assert match.ftr == "D"
      assert match.home_team == "some home_team"
      assert match.htag == 42
      assert match.hthg == 42
      assert match.htr == "D"
      assert match.match_date == ~D[2010-04-17]
      assert match.season == "some season"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = League.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      assert {:ok, %Match{} = match} = League.update_match(match, @update_attrs)
      assert match.away_team == "some updated away_team"
      assert match.division == "some updated division"
      assert match.ftag == 43
      assert match.fthg == 44
      assert match.ftr == "H"
      assert match.home_team == "some updated home_team"
      assert match.htag == 43
      assert match.hthg == 43
      assert match.htr == "D"
      assert match.match_date == ~D[2011-05-18]
      assert match.season == "some updated season"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = League.update_match(match, @invalid_attrs)
      assert match == League.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = League.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> League.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = League.change_match(match)
    end
  end
end
