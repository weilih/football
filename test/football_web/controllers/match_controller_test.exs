defmodule FootballWeb.MatchControllerTest do
  use FootballWeb.ConnCase

  alias Football.League
  alias Football.League.Match

  @create_attrs %{
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
  @update_attrs %{
    away_team: "some updated away_team",
    division: "some updated division",
    ftag: 43,
    fthg: 44,
    ftr: "H",
    home_team: "some updated home_team",
    htag: 43,
    hthg: 43,
    htr: "D",
    match_date: ~D[2011-05-18],
    season: "some updated season"
  }
  @invalid_attrs %{away_team: nil, division: nil, ftag: nil, fthg: nil, ftr: nil, home_team: nil, htag: nil, hthg: nil, htr: nil, match_date: nil, season: nil}

  def fixture(:match) do
    {:ok, match} = League.create_match(@create_attrs)
    match
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all matches", %{conn: conn} do
      conn = get(conn, Routes.match_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create match" do
    test "renders match when data is valid", %{conn: conn} do
      conn = post(conn, Routes.match_path(conn, :create), match: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.match_path(conn, :show, id))

      assert %{
               "id" => id,
               "away_team" => "some away_team",
               "division" => "some division",
               "ftag" => 42,
               "fthg" => 42,
               "ftr" => "D",
               "home_team" => "some home_team",
               "htag" => 42,
               "hthg" => 42,
               "htr" => "D",
               "match_date" => "2010-04-17",
               "season" => "some season"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.match_path(conn, :create), match: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update match" do
    setup [:create_match]

    test "renders match when data is valid", %{conn: conn, match: %Match{id: id} = match} do
      conn = put(conn, Routes.match_path(conn, :update, match), match: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.match_path(conn, :show, id))

      assert %{
               "id" => id,
               "away_team" => "some updated away_team",
               "division" => "some updated division",
               "ftag" => 43,
               "fthg" => 44,
               "ftr" => "H",
               "home_team" => "some updated home_team",
               "htag" => 43,
               "hthg" => 43,
               "htr" => "D",
               "match_date" => "2011-05-18",
               "season" => "some updated season"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, match: match} do
      conn = put(conn, Routes.match_path(conn, :update, match), match: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete match" do
    setup [:create_match]

    test "deletes chosen match", %{conn: conn, match: match} do
      conn = delete(conn, Routes.match_path(conn, :delete, match))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.match_path(conn, :show, match))
      end
    end
  end

  defp create_match(_) do
    match = fixture(:match)
    {:ok, match: match}
  end
end
