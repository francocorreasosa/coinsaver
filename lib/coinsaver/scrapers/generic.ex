defmodule Coinsaver.Scrapers.Generic do
  alias Coinsaver.Scrapers.ScrapingResult

  def scrap_with(fetch_data_function, extract_data_function) do
    case fetch_data_function.() do
      {:ok, data} -> extract_data_function.(data)
      {:error, reason} -> format_error(reason)
    end
  end

  def do_fetch_data(url) do
    case HTTPoison.get(url, [], ssl: [{:versions, [:"tlsv1.2"]}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def format_error(reason) do
    {:error, :http_error, reason}
  end

  def format_generic_rate(rate) do
    format_rates(rate, rate)
  end

  def format_rates(buy, sell) do
    sell_result = %ScrapingResult{kind: "sell", rate: sell}
    buy_result = %ScrapingResult{kind: "buy", rate: buy}

    {:ok, [buy_result, sell_result]}
  end

  @doc ~S"""
  Converts a float to integer keeping two digits after comma.

  ## Examples

  iex> Coinsaver.Scrapers.Generic.convert_to_storable_integer(12.34)
  1234

  iex> Coinsaver.Scrapers.Generic.convert_to_storable_integer(12.3432)
  1234

  iex> Coinsaver.Scrapers.Generic.convert_to_storable_integer(1234)
  123400
  """
  def convert_to_storable_integer(rate_as_float) do
    Kernel.trunc(rate_as_float * 100)
  end
end
