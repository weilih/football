defmodule FootballWeb.Router do
  use FootballWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FootballWeb do
    pipe_through :api

    resources "/matches", MatchController

    get "/league/:division/season/:season/matches", MatchController, :index
    get "/league/:division/season/:season/results", ResultController, :index
  end
end
