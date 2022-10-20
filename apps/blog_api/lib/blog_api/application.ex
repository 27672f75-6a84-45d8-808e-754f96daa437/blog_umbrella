defmodule BlogApi.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BlogApi.Telemetry,
      BlogApi.Endpoint
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    BlogApi.Endpoint.config_change(changed, removed)
    :ok
  end
end
