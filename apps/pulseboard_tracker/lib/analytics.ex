defmodule PulseboardCore.Analytics do
  alias PulseboardCore.{Projects, Events, Sessions, Users}

  def global_metrics(user_id) do
    %{
      total_projects: Projects.count_for_user(user_id),
      total_events: Events.count_for_user(user_id),
      active_sessions: Sessions.count_active_for_user(user_id),
      conversion_rate: compute_conversion_rate(user_id)
    }
  end

  def recent_activity(user_id, limit \\ 10) do
    Events.recent(user_id, limit)
  end

  def compute_conversion_rate(user_id) do
    visitors = Events.count_by_type(user_id, "visit")
    conversions = Events.count_by_type(user_id, "conversion")
    if visitors == 0, do: 0.0, else: Float.round(100 * conversions / visitors, 1)
  end
end
