defmodule PulseboardCore.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :public_key, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:projects, [:user_id])
    create unique_index(:projects, [:public_key])
  end
end
