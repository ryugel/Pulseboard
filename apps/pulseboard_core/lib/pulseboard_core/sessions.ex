defmodule PulseboardCore.Sessions do
  import Ecto.Query, warn: false
  alias PulseboardCore.Repo
  alias PulseboardCore.Schemas.Session

  def count_active_for_user(user_id) do
    recent = DateTime.utc_now() |> DateTime.add(-1800, :second) # 30 minutes
    from(s in Session, where: s.user_id == ^user_id and s.inserted_at > ^recent)
    |> Repo.aggregate(:count, :id)
  end
end
