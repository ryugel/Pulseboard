defmodule PulseboardWebWeb.DashboardController do
  use PulseboardWebWeb, :controller
  alias PulseboardCore.Repo
  alias PulseboardCore.Schemas.User


  def index(conn, _params) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to access the dashboard.")
        |> redirect(to: "/login")

     user ->
      metrics = PulseboardCore.Analytics.global_metrics(user.id)
      render(conn, :index, user: user, metrics: metrics)
        
    end
  end
end
