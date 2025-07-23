defmodule PulseboardWebWeb.SessionController do
  use PulseboardWebWeb, :controller
  alias PulseboardCore.Users


  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: "/dashboard")

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid credentials")
        |> render(:new)
    end
  end
end
