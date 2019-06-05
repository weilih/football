defmodule FootballWeb.MatchView do
  use FootballWeb, :view
  alias FootballWeb.MatchView
  alias FootballWeb.ProtobufMessages

  def render("index.json", %{matches: matches}) do
    %{data: render_many(matches, MatchView, "match.json")}
  end

  def render("show.json", %{match: match}) do
    %{data: render_one(match, MatchView, "match.json")}
  end

  def render("match.json", %{match: match}) do
    %{id: match.id,
      division: match.division,
      season: match.season,
      match_date: match.match_date,
      home_team: match.home_team,
      away_team: match.away_team,
      fthg: match.fthg,
      ftag: match.ftag,
      ftr: match.ftr,
      hthg: match.hthg,
      htag: match.htag,
      htr: match.htr}
  end

  def render("matches.proto", %{matches: matches}) do
    [matches: Enum.map(matches, &parse_proto/1)]
    |> ProtobufMessages.Matches.new()
    |> ProtobufMessages.Matches.encode()
  end

  defp parse_proto(match) do
    ProtobufMessages.Match.new(%{
      id: match.id,
      division: match.division,
      season: match.season,
      match_date: Date.to_iso8601(match.match_date),
      home_team: match.home_team,
      away_team: match.away_team,
      fthg: match.fthg,
      ftag: match.ftag,
      ftr: match.ftr,
      hthg: match.hthg,
      htag: match.htag,
      htr: match.htr
    })
  end
end
