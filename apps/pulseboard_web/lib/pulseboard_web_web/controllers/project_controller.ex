defmodule PulseboardWebWeb.ProjectController do
  use PulseboardWebWeb, :controller
  alias PulseboardCore.Projects
  alias PulseboardCore.Schemas.Project

  import Phoenix.Component, only: [to_form: 1]


 def new(conn, _params) do
  changeset = Projects.change_project(%Project{})
  form = to_form(changeset)
  render(conn, :new, form: form)
end

  def create(conn, %{"project" => project_params}) do
    current_user = conn.assigns.current_user

    case Projects.create_project(current_user, project_params) do
      {:ok, _project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: ~p"/dashboard")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
