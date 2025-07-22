defmodule PulseboardCore.Repo do
  use Ecto.Repo,
    otp_app: :pulseboard_core,
    adapter: Ecto.Adapters.Postgres
end
