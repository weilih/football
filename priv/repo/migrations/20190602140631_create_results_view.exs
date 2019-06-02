defmodule Football.Repo.Migrations.CreateResultsView do
  use Ecto.Migration

  def up do
    execute """
    CREATE VIEW results AS WITH home_matches AS (
      SELECT division, season, home_team AS team,
        COUNT(id) AS played,
        COUNT(id) FILTER (WHERE ftr = 'H') AS win,
        COUNT(id) FILTER (WHERE ftr = 'D') AS draw,
        COUNT(id) FILTER (WHERE ftr = 'A') AS lose,
        SUM(fthg) AS goals_for, SUM(ftag) AS goals_againts
      FROM matches GROUP BY division, season, home_team
    ), away_matches AS (
      SELECT division, season, away_team AS team,
        COUNT(id) AS played,
        COUNT(id) FILTER (WHERE ftr = 'A') AS win,
        COUNT(id) FILTER (WHERE ftr = 'D') AS draw,
        COUNT(id) FILTER (WHERE ftr = 'H') AS lose,
        SUM(Ftag) AS goals_for, SUM(fthg) AS goals_againts
      FROM matches GROUP BY division, season, away_team
    )
    SELECT division, season, team,
      SUM(played::integer) AS played,
      SUM(win::integer) AS win, SUM(draw::integer) AS draw, SUM(lose::integer) AS lose,
      SUM(goals_for::integer) AS goals_for, SUM(goals_againts::integer) AS goals_againts,
      (SUM(goals_for::integer) - SUM(goals_againts::integer)) AS goals_diffs,
      (SUM(win::integer) * 3 + SUM(draw::integer)) as points
    FROM (SELECT * FROM home_matches UNION SELECT * FROM away_matches) AS all_matches
    GROUP BY division, season, team
    ORDER BY points DESC, goals_for DESC;
    """
  end

  def down do
    execute "DROP VIEW results;"
  end
end
