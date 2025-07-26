defmodule PulseboardCore.Projects do
  import Ecto.Query, warn: false
  alias PulseboardCore.Repo
  alias PulseboardCore.Schemas.Project

  @doc """
  Returns the number of projects owned by the given user.
  """
  def count_for_user(user_id) do
    from(p in Project, where: p.user_id == ^user_id)
    |> Repo.aggregate(:count, :id)
  end
end
