defmodule PulseboardWebWeb.SessionControllerTest do
  use PulseboardWebWeb.ConnCase, async: true

  alias PulseboardCore.Users

  setup %{conn: conn} do
    email = "logout-#{System.unique_integer([:positive])}-#{System.os_time()}@ex.com"

    {:ok, _user} =
      Users.create_user(%{
        email: email,
        password: "secretpass",
        password_confirmation: "secretpass"
      })

    %{conn: conn, email: email}
  end

  test "POST /login logs in and redirects to dashboard", %{conn: conn, email: email} do
    conn =
      post(conn, ~p"/login", %{
        "user" => %{"email" => email, "password" => "secretpass"}
      })

    assert redirected_to(conn) == "/dashboard"
    assert get_session(conn, :user_id)
  end

  test "POST /login shows error with wrong credentials", %{conn: conn, email: email} do
    conn =
      post(conn, ~p"/login", %{
        "user" => %{"email" => email, "password" => "wrongpass"}
      })

    assert html_response(conn, 200) =~ "Invalid credentials"
  end

  test "DELETE /logout clears session and redirects to home", %{conn: conn} do
    email = "logout-#{System.unique_integer([:positive])}-#{System.os_time()}@ex.com"

    {:ok, user} =
      Users.create_user(%{
        email: email,
        password: "12345678",
        password_confirmation: "12345678"
      })

    conn =
      conn
      |> init_test_session(%{user_id: user.id})
      |> recycle()
      |> delete(~p"/logout")


    assert get_session(conn, :user_id) == nil
    assert redirected_to(conn) == ~p"/"

  end 

  test "GET /login redirects if already logged in", %{conn: conn, email: email} do
    {:ok, user} =
      Users.authenticate_user(email, "secretpass")

    conn =
      conn
      |> init_test_session(%{user_id: user.id})
      |> get(~p"/login")

    assert redirected_to(conn) == "/dashboard"
  end

  test "GET /register redirects if already logged in", %{conn: conn, email: email} do
    {:ok, user} =
      Users.authenticate_user(email, "secretpass")

    conn =
      conn
      |> init_test_session(%{user_id: user.id})
      |> get(~p"/register")

    assert redirected_to(conn) == "/dashboard"
  end

  test "POST /register creates user and redirects to dashboard", %{conn: conn} do
    email = "newuser-#{System.unique_integer([:positive])}@example.com"

    conn =
      post(conn, ~p"/register", %{
        "user" => %{
          "email" => email,
          "password" => "validpass123",
          "password_confirmation" => "validpass123"
        }
      })

    assert redirected_to(conn) == "/dashboard"
    assert get_session(conn, :user_id)
  end

  test "POST /register with mismatched passwords shows error", %{conn: conn} do
    conn =
      post(conn, ~p"/register", %{
        "user" => %{
          "email" => "fail@example.com",
          "password" => "short",
          "password_confirmation" => "diff"
        }
      })

    assert html_response(conn, 200) =~ "Could not create account"
  end

  test "POST /register with existing email shows error", %{conn: conn, email: email} do
    conn =
      post(conn, ~p"/register", %{
        "user" => %{
          "email" => email,
          "password" => "anotherpass123",
          "password_confirmation" => "anotherpass123"
        }
      })

    assert html_response(conn, 200) =~ "Could not create account"
  end

  test "GET /dashboard redirects if not logged in", %{conn: conn} do
    conn = get(conn, ~p"/dashboard")
    assert redirected_to(conn) == "/login"
  end
end
