defmodule Coinsaver.Exchange do
  @moduledoc """
  The Exchange context.
  """

  import Ecto.Query, warn: false
  alias Coinsaver.Repo

  alias Coinsaver.Exchange.Quote

  @doc """
  Creates a quote.

  ## Examples

      iex> create_quote(%{field: value})
      {:ok, %Quote{}}

      iex> create_quote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quote(attrs \\ %{}) do
    %Quote{}
    |> Quote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quote changes.

  ## Examples

      iex> change_quote(quote)
      %Ecto.Changeset{source: %Quote{}}

  """
  def change_quote(%Quote{} = quote) do
    Quote.changeset(quote, %{})
  end

  def get_last_job() do
    (
      from u in Oban.Job,
      order_by: [desc: u.id],
      limit: 1
    ) |> Repo.one()
  end

  def get_quotes_from_job(job, kind) do
    (
      from q in Quote,
        where: q.query_id == ^job.id and q.kind == ^kind and q.provider != "bcu",
        order_by: [desc: q.rate]
    ) |> Repo.all()
  end

  def get_bcu_rate() do
    (
      from q in Quote,
        where: q.provider == "bcu",
        order_by: [desc: q.inserted_at],
        limit: 1
    ) |> Repo.one()
  end
end
