defmodule Netgag.Router do
  use Netgag.Web, :router

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

  scope "/", Netgag do
    pipe_through :browser # Use the default browser stack
    resources "/gag", GagController, only: [:index, :show, :create]
    get "/watch/:id", WatchController, :show
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Netgag do
  #   pipe_through :api
  # end
end
