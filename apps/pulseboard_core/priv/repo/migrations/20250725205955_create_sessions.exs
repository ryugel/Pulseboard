defmodule PulseboardCore.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :device_type, :string
      add :active, :boolean, default: true
      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:sessions, [:user_id])
    create index(:sessions, [:project_id])
  end
end
