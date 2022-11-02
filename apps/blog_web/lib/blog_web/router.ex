defmodule BlogWeb.Router do
  use BlogWeb, :router

  import BlogWeb.UserAuth

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


    live "/posts", PostsLive
    live "/posts/:post_id", PostsLive, :show


    delete "/users/log_out", UserSessionController, :delete

    live_session :user, on_mount: {LiveAuth, :user} do

    end

    pipe_through :redirect_if_user_id_authenticated
      live "/users/register", AccountLive, :register
      live "/users/login", AccountLive, :login

      post "/users/register", UserSessionController, :register
      post "/users/login", UserSessionController, :login
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BlogWeb.Telemetry
    end
  end
end
