defmodule AuthX.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:first_name, :string, null: false)
      add(:last_name, :string)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:is_active, :boolean, null: false, default: true)
      add(:last_login, :naive_datetime_usec)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
