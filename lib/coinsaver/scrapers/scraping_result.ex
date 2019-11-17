defmodule Coinsaver.Scrapers.ScrapingResult do
  @enforce_keys [:kind, :rate]
  defstruct [:kind, :rate]
end
