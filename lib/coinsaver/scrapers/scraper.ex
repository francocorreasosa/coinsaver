defmodule Coinsaver.Scrapers.Scraper do
  @callback perform() :: {:ok, list(%Coinsaver.Scrapers.ScrapingResult{})} | {:error, String.t()}
end
