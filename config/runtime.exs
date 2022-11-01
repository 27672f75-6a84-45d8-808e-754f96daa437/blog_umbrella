import Config

if config_env() == :prod do
  config :blog_domain, BlogDomain.Repo,
    username: System.get_env("REPO_USERNAME"),
    password: System.get_env("REPO_PASSWORD"),
    hostname: System.get_env("REPO_HOSTNAME")

  config :blog_api, BlogApi.Endpoint, secret_key_base: System.get_env("SECRET_KEY_BASE")

  config :joken, default_signer: System.get_env("JOKEN_KEY_BASE")
end
