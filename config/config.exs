# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :coinsaver,
  ecto_repos: [Coinsaver.Repo]

# Configures the endpoint
config :coinsaver, CoinsaverWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wP90BXT+QWFgS1j4aI3bSyN9ShZQYnV3R3m/TixH63OiQroD3e7/C385F7KM+94r",
  render_errors: [view: CoinsaverWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Coinsaver.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :rihanna,
  producer_postgres_connection: {Ecto, Coinsaver.Repo}