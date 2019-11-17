defmodule Coinsaver.Scrapers.Aspen do
  import Coinsaver.Scrapers.Generic

  @behaviour Coinsaver.Scrapers.Scraper

  @url "https://www.aspen.com.uy/sitio/"

  def perform do
    scrap_with(&fetch_data/0, &extract_data/1)
  end

  defp fetch_data do
    do_fetch_data(@url)
  end

  defp extract_data(data) do
    buy =
      data
      |> Floki.find(".md-divisas table tr:nth-child(2) td:nth-child(2)")
      |> process_individual_value()

    sell =
      data
      |> Floki.find(".md-divisas table tr:nth-child(2) td:nth-child(3)")
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
