defmodule Coinsaver.Scrapers.Cambiame do
  import Coinsaver.Scrapers.Generic

  @behaviour Coinsaver.Scrapers.Scraper

  # Cambiame.uy uses the same rate as BCU and applies
  # a intermediation fee of 0.5% to each party.

  @url "https://www.bcu.gub.uy/Paginas/Default.aspx"

  def perform do
    scrap_with(&fetch_data/0, &extract_data/1)
  end

  defp fetch_data do
    do_fetch_data(@url)
  end

  defp extract_data(data) do
    bcu_rate = get_bcu_rate(data)
    cambiame_fee = (bcu_rate * 0.005) |> Kernel.trunc()

    buy = bcu_rate - cambiame_fee
    sell = bcu_rate + cambiame_fee

    format_rates(buy, sell)
  end

  defp get_bcu_rate(data) do
    data
    |> Floki.find("#2225 > div > div > span:nth-child(2)")
    |> Floki.text()
    |> String.replace("\r\n", "")
    |> String.trim()
    |> String.to_float()
    |> convert_to_storable_integer()
  end
end
