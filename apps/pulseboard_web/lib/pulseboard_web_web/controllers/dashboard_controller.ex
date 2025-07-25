defmodule PulseboardWebWeb.DashboardController do
  use PulseboardWebWeb, :controller

  def index(conn, _params) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to access the dashboard.")
        |> redirect(to: "/login")

      user ->
        render(conn, :index, user: user)
    end
  end
end
