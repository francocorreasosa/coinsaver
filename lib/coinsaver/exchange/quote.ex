defmodule Coinsaver.Exchange.Quote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotes" do
    field :date, :date
    field :kind, :string
    field :provider, :string
    field :query_id, :string
    field :rate, :integer

    timestamps()
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:provider, :kind, :rate, :query_id])
    |> validate_required([:provider, :kind, :rate, :query_id])
  end
end
