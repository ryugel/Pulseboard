# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :pulseboard_web,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :pulseboard_web, PulseboardWebWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PulseboardWebWeb.ErrorHTML, json: PulseboardWebWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PulseboardWeb.PubSub,
  live_view: [signing_salt: "0c2CUhVU"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  pulseboard_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/pulseboard_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  pulseboard_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/pulseboard_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pulseboard_core,
  ecto_repos: [PulseboardCore.Repo]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

  config :pulseboard_core, PulseboardCore.Repo,
 username: System.get_env("PGUSER"),
password: System.get_env("PGPASS"),
database: System.get_env("PGDB"),
hostname: System.get_env("PGHOST") || "localhost",
  port: 5432,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
