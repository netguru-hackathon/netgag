defmodule Netgag.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :user, :string
      add :gag_id, references(:gags, on_delete: :nothing)

      timestamps
    end
    create index(:comments, [:gag_id])

  end
end
