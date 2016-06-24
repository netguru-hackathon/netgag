defmodule Netgag.Repo.Migrations.CreateGag do
  use Ecto.Migration

  def change do
    create table(:gags) do
      add :slug, :string
      add :section, :string
      add :page, :string
      add :meme, :string

      timestamps
    end

    create unique_index(:gags, [:slug])
  end
end
