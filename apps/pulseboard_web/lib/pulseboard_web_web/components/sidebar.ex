defmodule PulseboardWebWeb.Components.Sidebar do
  use Phoenix.Component

  attr :current_page, :string, required: true

  def sidebar(assigns) do
    ~H"""
    <aside class="bg-[#0f172a] text-white w-64 min-h-screen px-6 py-8 space-y-8 fixed">
      <h1 class="text-2xl font-bold mb-6">Pulseboard</h1>

      <nav class="space-y-2 text-base font-medium">
        <%= nav_link("Dashboard", "/dashboard", @current_page == "dashboard") %>
        <%= nav_link("Projects", "/projects", @current_page == "projects") %>
        <%= nav_link("Analytics", "/analytics", @current_page == "analytics") %>
        <%= nav_link("Settings", "/settings", @current_page == "settings") %>
      </nav>
    </aside>
    """
  end

  defp nav_link(label, path, active?) do
    active_class =
      if active?, do: "bg-[#1e293b] text-white", else: "text-gray-400 hover:text-white hover:bg-[#1e293b]"

    assigns = %{label: label, path: path, active_class: active_class}

    ~H"""
    <.link navigate={@path} class={"block px-4 py-2 rounded-lg transition #{@active_class}"}>
      <%= @label %>
    </.link>
    """
  end
end
