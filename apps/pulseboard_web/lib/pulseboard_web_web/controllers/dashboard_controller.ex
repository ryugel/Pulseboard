defmodule PulseboardWebWeb.DashboardController do
  use PulseboardWebWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
