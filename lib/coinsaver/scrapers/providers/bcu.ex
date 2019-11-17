defmodule Coinsaver.Scrapers.BCU do
  # TODO: Migrate to use the official SOAP API
  # (yes it's almost 2020 and using a SOAP API is an improvement -_-)

  import Coinsaver.Scrapers.Generic

  @behaviour Coinsaver.Scrapers.Scraper

  @url "https://www.bcu.gub.uy/Paginas/Default.aspx"

  def perform do
    scrap_with(&fetch_data/0, &extract_data/1)
  end

  defp fetch_data do
    do_fetch_data(@url)
  end

  defp extract_data(data) do
    data
    |> Floki.find(".Cotizaciones table tr:nth-child(2) td:nth-child(3)")
    |> Floki.text()
    |> String.replace("\r\n", "")
    |> String.trim()
    |> String.to_float()
    |> convert_to_storable_integer()
    |> format_generic_rate()
  end
end
