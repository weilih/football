defmodule FootballWeb.ResultView do
  use FootballWeb, :view
  alias FootballWeb.ResultView

  def render("index.json", %{results: results}) do
    %{data: render_many(results, ResultView, "result.json")}
  end

  def render("show.json", %{result: result}) do
    %{data: render_one(result, ResultView, "match.json")}
  end

  def render("result.json", %{result: result}) do
    %{division: result.division,
      season: result.season,
      played: result.played,
      win: result.win,
      lose: result.lose,
      goals_for: result.goals_for,
      goals_againts: result.goals_againts,
      goals_diffs: result.goals_diffs,
      points: result.points}
  end
end
