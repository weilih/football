defmodule FootballWeb.MatchControllerTest do
  use FootballWeb.ConnCase

  alias Football.League
  alias Football.League.Match

  @attrs %{
    away_team: "some away_team",
    division: "some division",
    ftag: 42,
    fthg: 42,
    ftr: "D",
    home_team: "some home_team",
    htag: 42,
    hthg: 42,
    htr: "D",
    match_date: ~D[2010-04-17],
    season: "some season"
  }

  def fixture(:match) do
    Match
    |> struct(@attrs)
    |> Football.Repo.insert!()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all matches", %{conn: conn} do
      conn = get(conn, "/api/league/some%20division/season/some%20season/matches")
      assert json_response(conn, 200)["data"] == []
    end
  end
end
