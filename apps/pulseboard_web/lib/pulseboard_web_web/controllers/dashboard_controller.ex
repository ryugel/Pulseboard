defmodule PulseboardWebWeb.DashboardController do
  use PulseboardWebWeb, :controller
  alias PulseboardCore.Repo
  alias PulseboardCore.Schemas.User

  import Ecto.Query

  def index(conn, _params) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_flash(:error, "You must be logged in to access the dashboard.")
        |> redirect(to: "/login")

      user ->
        user = Repo.preload(user, :projects)

        render(conn, :index,
          user: user,
          projects: user.projects
        )
    end
  end
end
