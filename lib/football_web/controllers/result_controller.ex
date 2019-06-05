defmodule FootballWeb.ResultController do
  use FootballWeb, :controller

  alias Football.League

  action_fallback FootballWeb.FallbackController

  def index(%{private: %{phoenix_format: "proto"}} = conn,
            %{"division" => division, "season" => season}) do
    results = League.list_results(division, season)

    conn
    |> put_resp_content_type("application/protobuf", "binary")
    |> render("results.proto", results: results)
  end

  def index(conn, %{"division" => division, "season" => season}) do
    results = League.list_results(division, season)
    render(conn, "index.json", results: results)
  end
end
