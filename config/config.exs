import Config

config :blog_domain,
  ecto_repos: [BlogDomain.Repo]

config :blog_api,
  ecto_repos: [BlogDomain.Repo],
  generators: [context_app: :blog_domain]

config :blog_api, BlogApi.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BlogApi.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Blog.PubSub,
  live_view: [signing_salt: "Og51exPx"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
