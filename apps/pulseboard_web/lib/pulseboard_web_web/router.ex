defmodule PulseboardWebWeb.Router do
  use PulseboardWebWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PulseboardWebWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug :fetch_session
    plug PulseboardWebWeb.Plugs.Auth
  end

  scope "/", PulseboardWebWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/register", SessionController, :register
    post "/register", SessionController, :create_account
  end

  scope "/", PulseboardWebWeb do
    pipe_through [:browser, :protected]

    get "/dashboard", DashboardController, :index
    delete "/logout", SessionController, :delete

    get "/projects/new", ProjectController, :new
    post "/projects", ProjectController, :create
  end
  # Other scopes may use custom stacks.
  # scope "/api", PulseboardWebWeb do
  #   pipe_through :api
  # end
end
