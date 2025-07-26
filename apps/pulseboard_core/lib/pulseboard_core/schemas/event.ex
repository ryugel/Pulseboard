defmodule PulseboardCore.Schemas.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :properties, :map
    belongs_to :project, PulseboardCore.Schemas.Project
    belongs_to :user, PulseboardCore.Users.User

    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :properties, :project_id, :user_id])
    |> validate_required([:name, :project_id, :user_id])
  end
end
