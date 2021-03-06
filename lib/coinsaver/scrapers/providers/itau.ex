defmodule Coinsaver.Scrapers.Itau do
  import Coinsaver.Scrapers.Generic

  @behaviour Coinsaver.Scrapers.Scraper

  @url "https://www.itau.com.uy/inst/aci/cotiz.xml"

  def perform do
    scrap_with(&fetch_data/0, &extract_data/1)
  end

  defp fetch_data do
    do_fetch_data(@url)
  end

  defp extract_data(data) do
    buy = data |> Floki.find("cotizacion:nth-child(2) compra") |> process_individual_value()
    sell = data |> Floki.find("cotizacion:nth-child(2) venta") |> process_individual_value()

    format_rates(buy, sell)
  end

  defp process_individual_value(value) do
    Floki.text(value)
    |> String.to_float()
    |> convert_to_storable_integer()
  end
end
