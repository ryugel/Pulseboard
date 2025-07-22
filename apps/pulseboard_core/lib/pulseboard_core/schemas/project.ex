defmodule PulseboardCore.Schemas.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :public_key, :string

    belongs_to :user, PulseboardCore.Schemas.User

    timestamps()
  end

  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :public_key, :user_id])
    |> validate_required([:name, :public_key, :user_id])
    |> unique_constraint(:public_key)
  end
end
