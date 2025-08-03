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
    case {conn.assigns[:current_user], get_session(conn, :user_id)} do
      {current_user, _} when not is_nil(current_user) ->
        conn

      {_, user_id} when not is_nil(user_id) ->
        case Users.get_user(user_id) do
          nil -> redirect_to_login(conn)
          user -> assign(conn, :current_user, user)
        end

      _ ->
        redirect_to_login(conn)
    end
  end

  defp redirect_to_login(conn) do
    conn
    |> redirect(to: ~p"/login")
    |> halt()
  end
end
