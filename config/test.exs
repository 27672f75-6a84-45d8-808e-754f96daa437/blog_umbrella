import Config

config :blog_domain, BlogDomain.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "blog_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  port: 25432

config :blog_api, BlogApi.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6Cj17Np3w0isXTKfOSz14kmW8tFKBu8RHw8II4HVL1WbOqaQqBO17VNx2ocngSZH",
  server: false

config :logger, level: :warn

config :phoenix, :plug_init_mode, :runtime

config :argon2_elixir, :rounds, 1

config :joken, default_signer: "WyXp6HJItNZqkSvkPUHsQWKnChlLQQ+J8f3dMYCrQCKCfNpFiw8bjsd2+LOmGJOA"
