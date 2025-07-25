defmodule PulseboardCore.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset
  
  @email_regex ~r/@/
  @password_min_length 8

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :hashed_password, :string

    has_many :projects, PulseboardCore.Schemas.Project

    timestamps()
  end

  @doc """
  Changeset standard (par ex. pour éditer un user).
  """
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_email()
    |> validate_password()
    |> unique_constraint(:email, name: :users_email_index)
    |> put_password_hash()
  end

  @doc """
  Changeset spécifique à l'inscription.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_email()
    |> validate_password()
    |> validate_confirmation(:password, message: "does not match confirmation")
    |> unique_constraint(:email, name: :users_email_index)
    |> put_password_hash()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_format(:email, @email_regex, message: "must be a valid email address")
  end

  defp validate_password(changeset) do
    changeset
    |> validate_length(:password, min: @password_min_length)
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(password))
    end
  end
end
