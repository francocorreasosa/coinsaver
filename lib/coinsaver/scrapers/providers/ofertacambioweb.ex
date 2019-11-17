defmodule Coinsaver.Scrapers.OfertaCambioWeb do
  import Coinsaver.Scrapers.Generic

  @behaviour Coinsaver.Scrapers.Scraper

  @url "https://ofertacambioweb-assets.s3.amazonaws.com/cotizacion.JSON"

  def perform do
    scrap_with(&fetch_data/0, &extract_data/1)
  end

  defp fetch_data do
    do_fetch_data(@url)
  end

  defp extract_data(data) do
    {:ok, payload} = Jason.decode(data)

    buy =
      payload
      |> Map.get("COMPRA")
      |> process_individual_value()

    sell =
      payload
      |> Map.get("VENTA")
      |> process_individual_value()

    format_rates(buy, sell)
  end

  defp process_individual_value(value) do
    value
    |> String.replace("$", "")
    |> String.trim()
    |> String.to_float()
    |> convert_to_storable_integer()
  end
end
