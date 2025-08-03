defmodule PulseboardWebWeb.Plugs.RedirectAuthenticatedUser do
  import Plug.Conn
  import Phoenix.Controller

  use Phoenix.VerifiedRoutes,
    endpoint: PulseboardWebWeb.Endpoint,
    router: PulseboardWebWeb.Router,
    statics: []

  def init(opts), do: opts

  def call(conn, _opts) do
    if get_session(conn, :user_id) do
      conn
      |> redirect(to: ~p"/dashboard")
      |> halt()
    else
      conn
    end
  end
end
