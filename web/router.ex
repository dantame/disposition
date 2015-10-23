defmodule Disposition.Router do
  use Disposition.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Disposition do
    pipe_through :api

    resources "/sentiments", SentimentController, except: [:new, :edit]
  end
end
