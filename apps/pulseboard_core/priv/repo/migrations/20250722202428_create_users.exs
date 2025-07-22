defmodule PulseboardCore.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string
      add :hashed_password, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
