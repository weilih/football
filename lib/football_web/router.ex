defmodule FootballWeb.Router do
  use FootballWeb, :router

  pipeline :api do
    plug :accepts, ["json", "proto"]
  end

  scope "/api", FootballWeb do
    pipe_through :api

    get "/league/:division/season/:season/matches", MatchController, :index
    get "/league/:division/season/:season/results", ResultController, :index
  end
end
