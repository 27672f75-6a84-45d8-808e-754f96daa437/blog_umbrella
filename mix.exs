defmodule Blog.Umbrella.MixProject do
  use Mix.Project

  def project() do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: releases()
    ]
  end

  defp deps() do
    []
  end

  defp aliases() do
    [
      ecto_test_setup: ["cmd --app blog_domain MIX_ENV=test mix ecto.test_setup"],
      setup: ["cmd mix setup"]
    ]
  end

  defp releases() do
    [
      blog_umbrella: [
        include_executables_for: [:unix],
        applications: [
          blog: :permanent,
          blog_domain: :permanent,
          blog_api: :permanent
        ]
      ]
    ]
  end
end
