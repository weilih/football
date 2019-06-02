defmodule FootballWeb.ResultController do
  use FootballWeb, :controller

  alias Football.League

  action_fallback FootballWeb.FallbackController

  def index(conn, %{"division" => division, "season" => season}) do
    results = League.list_results(division, season)
    render(conn, "index.json", results: results)
  end
end
