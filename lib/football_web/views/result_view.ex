defmodule FootballWeb.ResultView do
  use FootballWeb, :view
  alias FootballWeb.ResultView
  alias FootballWeb.ProtobufMessages

  def render("index.json", %{results: results}) do
    %{data: render_many(results, ResultView, "result.json")}
  end

  def render("result.json", %{result: result}) do
    %{division: result.division,
      season: result.season,
      played: result.played,
      team: result.team,
      win: result.win,
      lose: result.lose,
      goals_for: result.goals_for,
      goals_againts: result.goals_againts,
      goals_diffs: result.goals_diffs,
      points: result.points}
  end

  def render("results.proto", %{results: results}) do
    [results: Enum.map(results, &parse_proto/1)]
    |> ProtobufMessages.Results.new()
    |> ProtobufMessages.Results.encode()
  end

  defp parse_proto(result) do
    ProtobufMessages.Result.new(%{
      division: result.division,
      season: result.season,
      team: result.team,
      played: result.played,
      win: result.win,
      lose: result.lose,
      goals_for: result.goals_for,
      goals_againts: result.goals_againts,
      goals_diffs: result.goals_diffs,
      points: result.points
    })
  end
end
