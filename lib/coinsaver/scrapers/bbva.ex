defmodule Coinsaver.Scrapers.Bbva do
  import Coinsaver.Scrapers.Generic

  @behaviour Coinsaver.Scrapers.Scraper

  @url "https://bbvanet.bbva.com.uy/WebInst/Cotizaciones"

  def perform do
    scrap_with(&fetch_data/0, &extract_data/1)
  end

  defp fetch_data do
    do_fetch_data(@url)
  end

  defp extract_data(data) do
    buy =
      data
      |> Floki.find("tbody > tr:nth-child(2) > .buy_lat")
      |> process_individual_value()

    sell =
      data
      |> Floki.find("tbody > tr:nth-child(2) > .sell_lat")
      |> process_individual_value()

    format_rates(buy, sell)
  end

  defp process_individual_value(value) do
    Floki.text(value)
    |> String.trim()
    |> String.to_float()
    |> convert_to_storable_integer()
  end
end
