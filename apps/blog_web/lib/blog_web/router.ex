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

    delete "/users/log_out", UserSessionController, :delete

    live_session :user, on_mount: {BlogWeb.LiveAuth, :user} do
      live "/posts", PostLive.Index, :index
      live "/posts/new", PostLive.Index, :new
      live "/posts/:post_id/edit", PostLive.Index, :edit
      # live "/posts/:post_id", PostLive, :index
    end


    # live_session :user, on_mount: {BlogWeb.LiveAuth, :user} do
    #   live "/posts", PostsLive, :index
    #   live "/posts/new", PostsLive, :new
    #   live "/posts/:post_id", PostLive, :index
    #   live "/posts/:post_id/edit", PostLive, :edit
    # end
  end

  scope "/", BlogWeb do
    pipe_through [:browser, :redirect_if_user_id_authenticated]

    live "/users/register", RegisterLive, :register
    live "/users/login", LoginLive, :login

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
