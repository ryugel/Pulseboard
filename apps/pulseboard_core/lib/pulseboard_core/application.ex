defmodule PulseboardCore.Application do
  use Application

  def start(_type, _args) do
    children = [
      PulseboardCore.Repo
    ]

    opts = [strategy: :one_for_one, name: PulseboardCore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
