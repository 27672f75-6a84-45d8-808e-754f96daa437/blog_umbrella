defmodule BlogApi.Router do
  use BlogApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BlogApi do
    pipe_through :api

    resources "/users", UserController, only: [:index, :show, :update]
    post "/register", UserController, :register

    resources "/posts", PostController, only: [:index, :show, :create, :update, :delete]

    resources "/posts/:post_id/comments", CommentController,
      only: [:index, :show, :create, :update, :delete]
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BlogApi.Telemetry
    end
  end
end
