defmodule Coinsaver.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :provider, :string
      add :kind, :string
      add :rate, :integer
      add :date, :date
      add :query_id, :integer

      timestamps()
    end

  end
end
