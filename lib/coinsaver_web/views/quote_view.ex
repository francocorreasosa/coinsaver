defmodule CoinsaverWeb.QuoteView do
  use CoinsaverWeb, :view
  alias CoinsaverWeb.QuoteView

  def render("index.json", %{quotes: quotes}) do
    %{data: render_many(quotes, QuoteView, "quote.json")}
  end

  def render("show.json", %{quote: quote}) do
    %{data: render_one(quote, QuoteView, "quote.json")}
  end

  def render("quote.json", %{quote: quote}) do
    %{id: quote.id,
      provider: quote.provider,
      kind: quote.kind,
      rate: quote.rate,
      date: quote.date,
      query_id: quote.query_id}
  end
end
