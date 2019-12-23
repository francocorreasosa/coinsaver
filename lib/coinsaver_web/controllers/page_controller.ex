defmodule CoinsaverWeb.PageController do
  use CoinsaverWeb, :controller
  alias Coinsaver.Repo
  alias Coinsaver.Exchange
  alias Coinsaver.Exchange.Quote

  import Ecto.Query, only: [from: 2]

  def index(conn, %{"kind" => kind}) do
    raw_quotes = 
      Exchange.get_last_job()
      |> Exchange.get_quotes_from_job(kind)
    bcu_rate = Exchange.get_bcu_rate()
    
    quotes = if kind == "sell", do: Enum.reverse(raw_quotes), else: raw_quotes

    render(conn, "index.html", quotes: quotes, kind: kind, bcu_rate: bcu_rate)
  end

  def index(conn, _params) do
    index(conn, %{"kind" => "sell"})
  end
end
