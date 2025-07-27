defmodule PulseboardWebWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.VerifiedRoutes, only: [sigil_p: 2]

  alias PulseboardCore.Users

  use Phoenix.VerifiedRoutes,
    endpoint: PulseboardWebWeb.Endpoint,
    router: PulseboardWebWeb.Router,
    statics: []

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      conn.assigns[:current_user] ->
        conn

      user = user_id && Users.get_user!(user_id) ->
        assign(conn, :current_user, user)

      true ->
        conn
        |> redirect(to: ~p"/login")
        |> halt()
    end
  end
end
