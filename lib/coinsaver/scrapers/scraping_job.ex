defmodule Coinsaver.Scrapers.ScrapingJob do
  @behaviour Rihanna.Job

  alias Coinsaver.Scrapers

  def perform(arg) do
    query_id =  Ecto.UUID.generate()

    pmap([
      Scrapers.Aspen,
      Scrapers.BCU,
      Scrapers.Bandes,
      Scrapers.Bbva,
      Scrapers.Brou,
      Scrapers.Cambiame,
      Scrapers.Cambilex,
      Scrapers.Fortex,
      Scrapers.Gales,
      Scrapers.Itau,
      Scrapers.Matriz,
      Scrapers.OfertaCambioWeb
    ], fn x -> x.perform() |> process_results(x, query_id) end)

    Rihanna.schedule({Coinsaver.Scrapers.ScrapingJob, :perform, [[]]}, in: :timer.minutes(5))

    :ok
  end

  # TODO: move to own module
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  def process_results(result, type, query_id) do
    case result do
      {:ok, rates} ->
        Enum.map(rates, fn rate -> process_individual_result(type, rate, query_id) end)
        {:ok}
      {:error, error, reason} -> process_error(query_id, error, reason)
    end
  end

  def process_individual_result(type, rate_package, query_id) do
    IO.inspect(query_id)
    provider = type |> to_string |> String.replace("Elixir.Coinsaver.Scrapers.", "") |> String.downcase
    %Coinsaver.Scrapers.ScrapingResult{kind: kind, rate: rate} = rate_package
    db_item = Coinsaver.Exchange.create_quote(%{
      kind: kind,
      rate: rate,
      provider: provider,
      query_id: query_id
    })

    IO.inspect(db_item)
  end

  def process_error(query_id, error, reason) do 
    # TODO: make it right
    IO.puts("HTTP Timeout error in" <> query_id <> " " <> to_string(error) <> " " <> to_string(reason))
  end
  
end
