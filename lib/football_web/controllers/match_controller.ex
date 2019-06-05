defmodule FootballWeb.MatchController do
  use FootballWeb, :controller

  alias Football.League
  alias Football.League.Match

  action_fallback FootballWeb.FallbackController

  def index(%{private: %{phoenix_format: "proto"}} = conn,
            %{"division" => division, "season" => season}) do
    matches = League.list_matches(division, season)

    conn
    |> put_resp_content_type("application/protobuf", "binary")
    |> render("matches.proto", matches: matches)
  end

  def index(conn, %{"division" => division, "season" => season}) do
    matches = League.list_matches(division, season)
    render(conn, "index.json", matches: matches)
  end

  def index(conn, _params) do
    matches = League.list_matches()
    render(conn, "index.json", matches: matches)
  end

  def create(conn, %{"match" => match_params}) do
    with {:ok, %Match{} = match} <- League.create_match(match_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.match_path(conn, :show, match))
      |> render("show.json", match: match)
    end
  end

  def show(%{private: %{phoenix_format: "proto"}} = conn, %{"id" => id}) do
    match = League.get_match!(id)

    conn
    |> put_resp_content_type("application/protobuf", "binary")
    |> render("match.proto", match: match)
  end

  def show(conn, %{"id" => id}) do
    match = League.get_match!(id)
    render(conn, "show.json", match: match)
  end

  def update(conn, %{"id" => id, "match" => match_params}) do
    match = League.get_match!(id)

    with {:ok, %Match{} = match} <- League.update_match(match, match_params) do
      render(conn, "show.json", match: match)
    end
  end

  def delete(conn, %{"id" => id}) do
    match = League.get_match!(id)

    with {:ok, %Match{}} <- League.delete_match(match) do
      send_resp(conn, :no_content, "")
    end
  end
end
