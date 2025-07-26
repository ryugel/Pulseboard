defmodule PulseboardCore.Events do
  import Ecto.Query, warn: false
  alias PulseboardCore.Repo
  alias PulseboardCore.Schemas.Event

  def count_for_user(user_id) do
    from(e in Event, where: e.user_id == ^user_id)
    |> Repo.aggregate(:count, :id)
  end

  def count_by_type(user_id, name) do
    from(e in PulseboardCore.Schemas.Event,
      where: e.user_id == ^user_id and e.name == ^name,
      select: count(e.id)
    )
    |> PulseboardCore.Repo.one()
  end
end
