defmodule Disposition.Repo.Migrations.CreateSentiment do
  use Ecto.Migration

  def change do
    create table(:sentiments) do
      add :origin, :string
      add :sentiment, :string
      add :actor, :string
      add :metadata, :map

      timestamps
    end

  end
end
