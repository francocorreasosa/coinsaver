defmodule Coinsaver.ExchangeTest do
  use Coinsaver.DataCase

  alias Coinsaver.Exchange

  describe "quotes" do
    alias Coinsaver.Exchange.Quote

    @valid_attrs %{date: ~D[2010-04-17], kind: "some kind", provider: "some provider", query_id: 42, rate: 42}
    @update_attrs %{date: ~D[2011-05-18], kind: "some updated kind", provider: "some updated provider", query_id: 43, rate: 43}
    @invalid_attrs %{date: nil, kind: nil, provider: nil, query_id: nil, rate: nil}

    def quote_fixture(attrs \\ %{}) do
      {:ok, quote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Exchange.create_quote()

      quote
    end

    test "list_quotes/0 returns all quotes" do
      quote = quote_fixture()
      assert Exchange.list_quotes() == [quote]
    end

    test "get_quote!/1 returns the quote with given id" do
      quote = quote_fixture()
      assert Exchange.get_quote!(quote.id) == quote
    end

    test "create_quote/1 with valid data creates a quote" do
      assert {:ok, %Quote{} = quote} = Exchange.create_quote(@valid_attrs)
      assert quote.date == ~D[2010-04-17]
      assert quote.kind == "some kind"
      assert quote.provider == "some provider"
      assert quote.query_id == 42
      assert quote.rate == 42
    end

    test "create_quote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Exchange.create_quote(@invalid_attrs)
    end

    test "update_quote/2 with valid data updates the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{} = quote} = Exchange.update_quote(quote, @update_attrs)
      assert quote.date == ~D[2011-05-18]
      assert quote.kind == "some updated kind"
      assert quote.provider == "some updated provider"
      assert quote.query_id == 43
      assert quote.rate == 43
    end

    test "update_quote/2 with invalid data returns error changeset" do
      quote = quote_fixture()
      assert {:error, %Ecto.Changeset{}} = Exchange.update_quote(quote, @invalid_attrs)
      assert quote == Exchange.get_quote!(quote.id)
    end

    test "delete_quote/1 deletes the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{}} = Exchange.delete_quote(quote)
      assert_raise Ecto.NoResultsError, fn -> Exchange.get_quote!(quote.id) end
    end

    test "change_quote/1 returns a quote changeset" do
      quote = quote_fixture()
      assert %Ecto.Changeset{} = Exchange.change_quote(quote)
    end
  end
end
