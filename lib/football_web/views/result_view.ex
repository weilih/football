defmodule FootballWeb.ResultView do
  use FootballWeb, :view
  alias FootballWeb.ResultView

  def render("index.json", %{results: results}) do
    %{data: render_many(results, ResultView, "result.json")}
  end

  def render("show.json", %{result: result}) do
    %{data: render_one(result, ResultView, "result.json")}
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

  def render("results.proto", %{results: results}) do
    [results: Enum.map(results, &parse_proto/1)]
    |> FootballWeb.Protobuf.Messages.Results.new()
    |> FootballWeb.Protobuf.Messages.Results.encode()
  end

  def render("result.proto", %{result: result}) do
    result
    |> parse_proto()
    |> FootballWeb.Protobuf.Messages.Result.encode()
  end

  defp parse_proto(result) do
    FootballWeb.Protobuf.Messages.Result.new(%{
      division: result.division,
      season: result.season,
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
