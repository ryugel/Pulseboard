defmodule PulseboardCore.Schemas.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :device_type, :string
    field :active, :boolean, default: true
    belongs_to :project, PulseboardCore.Schemas.Project
    belongs_to :user, PulseboardCore.Users.User

    timestamps()
  end

  def changeset(session, attrs) do
    session
    |> cast(attrs, [:device_type, :project_id, :user_id, :active])
    |> validate_required([:device_type, :project_id, :user_id])
  end
end
