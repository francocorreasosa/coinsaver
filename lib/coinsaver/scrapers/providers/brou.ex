defmodule Coinsaver.Scrapers.Brou do
  import Coinsaver.Scrapers.Generic

  @behaviour Coinsaver.Scrapers.Scraper

  @url "https://www.brou.com.uy/c/portal/render_portlet?p_l_id=20593&p_p_id=cotizacionfull_WAR_broutmfportlet_INSTANCE_otHfewh1klyS&p_p_lifecycle=0&p_t_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=0&p_p_col_count=2&p_p_isolated=1&currentURL=%2Fweb%2Fguest%2Fcotizaciones"

  def perform do
    scrap_with(&fetch_data/0, &extract_data/1)
  end

  defp fetch_data do
    do_fetch_data(@url)
  end

  defp extract_data(data) do
    buy =
      data
      |> Floki.find("table > tbody > tr:nth-child(1) > td:nth-child(3)")
      |> process_individual_value()

    sell =
      data
      |> Floki.find("table > tbody > tr:nth-child(1) > td:nth-child(5)")
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
