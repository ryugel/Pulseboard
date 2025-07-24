defmodule PulseboardWebWeb.SessionController do
  use PulseboardWebWeb, :controller
  alias PulseboardCore.Users
  alias PulseboardCore.Users.User
  alias PulseboardCore.Schemas.User

  def new(conn, _params) do
    render(conn, :new, changeset: Users.change_user(%User{}))
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, user} <- Users.authenticate_user(email, password) do
      conn
      |> put_session(:user_id, user.id)
      |> configure_session(renew: true)
      |> put_flash(:info, "Welcome back!")
      |> redirect(to: "/dashboard")
    else
      _ ->
        conn
        |> put_flash(:error, "Invalid credentials")
        |> render(:new, changeset: Users.change_user(%User{}))
    end
  end

  def register(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, :register, changeset: changeset)
  end

  def create_account(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Account created successfully!")
        |> redirect(to: "/dashboard")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Could not create account")
        |> render(:register, changeset: changeset)
    end
  end
end
