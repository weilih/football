defmodule FootballWeb.Protobuf.Messages do
  use Protobuf, """
    syntax = "proto3";
    import "google/protobuf/date.proto";

    message Matches {
      repeated Match matches = 1;
    }

    message Match {
      uint64 id = 1;

      string division = 2;
      string season = 3;

      string match_date = 4;
      string home_team = 5;
      string away_team = 6;

      uint32 fthg = 7;
      uint32 ftag = 8;
      string ftr = 9;

      uint32 hthg = 10;
      uint32 htag = 11;
      string htr = 12;
    }

    message Results {
      repeated Result results = 1;
    }

    message Result {
      string division = 1;
      string season = 2;

      uint32 played = 3;
      uint32 win = 4;
      uint32 lose = 5;

      uint32 goals_for = 6;
      uint32 goals_againts = 7;
      sint32 goals_diffs = 8;
      uint32 points = 9;
    }
  """
end
