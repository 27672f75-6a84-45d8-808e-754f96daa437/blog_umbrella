import Config

config :blog_domain, BlogDomain.Repo,
  database: "blog_prod",
  pool_size: 10,
  port: 5432,
  priv: "priv/repo"

config :blog_api, BlogApi.Endpoint,
  url: [scheme: "https", host: "api.foo.bar", port: 443],
  http: [
    port: 8080,
    transport_options: [
      socket_opts: [:inet6],
      num_acceptors: 1_000,
      max_connections: 1_048_576
    ]
  ],
  server: true,
  check_origin: false

config :logger, level: :info
