defmodule BlogWeb.Router do
  use BlogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BlogWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BlogWeb.UserPlug
  end

  scope "/", BlogWeb do
    pipe_through :browser

    live "/", PageLive
    live "/users/register", AccountLive, :register
    live "/users/login", AccountLive, :login

    post "/users/register", UserSessionController, :register
    post "/users/login", UserSessionController, :login
    delete "/users/log_out", UserSessionController, :delete
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BlogWeb.Telemetry
    end
  end
end
