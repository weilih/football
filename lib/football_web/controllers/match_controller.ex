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
end
