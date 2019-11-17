defmodule Coinsaver.Scrapers.Fortex do
  import Coinsaver.Scrapers.Generic

  @behaviour Coinsaver.Scrapers.Scraper

  @url "https://www.fortex.com.uy/api/ex"

  def perform do
    scrap_with(&fetch_data/0, &extract_data/1)
  end

  defp fetch_data do
    do_fetch_data(@url)
  end

  defp extract_data(data) do
    {:ok, payload} = Jason.decode(data)

    raw_buy = payload |> Map.get("conversions") |> Map.get("USD") |> Map.get("UYU")
    raw_sell_inverted = payload |> Map.get("conversions") |> Map.get("UYU") |> Map.get("USD")
    raw_sell = 1 / raw_sell_inverted

    buy = convert_to_storable_integer(raw_buy)
    sell = convert_to_storable_integer(raw_sell)

    format_rates(buy, sell)
  end
end
