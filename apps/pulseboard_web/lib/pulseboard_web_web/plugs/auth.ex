defmodule PulseboardWebWeb.Plugs.Auth do
  @moduledoc """
  Plug responsable de charger l'utilisateur courant dans `conn.assigns[:current_user]`.
  """
  import Plug.Conn
  alias PulseboardCore.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    user = get_session(conn, :user_id) |> maybe_get_user()
    assign(conn, :current_user, user)
  end

  defp maybe_get_user(nil), do: nil
  defp maybe_get_user(user_id), do: Users.get_user!(user_id)
end
