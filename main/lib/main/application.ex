defmodule Main.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MainWeb.Telemetry,
      Main.Repo,
      {DNSCluster, query: Application.get_env(:main, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Main.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Main.Finch},
      # Start a worker by calling: Main.Worker.start_link(arg)
      # {Main.Worker, arg},
      # Start to serve requests, typically the last entry
      MainWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Main.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MainWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
