defmodule CoinsaverWeb.QuoteControllerTest do
  use CoinsaverWeb.ConnCase

  alias Coinsaver.Exchange
  alias Coinsaver.Exchange.Quote

  @create_attrs %{
    date: ~D[2010-04-17],
    kind: "some kind",
    provider: "some provider",
    query_id: 42,
    rate: 42
  }
  @update_attrs %{
    date: ~D[2011-05-18],
    kind: "some updated kind",
    provider: "some updated provider",
    query_id: 43,
    rate: 43
  }
  @invalid_attrs %{date: nil, kind: nil, provider: nil, query_id: nil, rate: nil}

  def fixture(:quote) do
    {:ok, quote} = Exchange.create_quote(@create_attrs)
    quote
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all quotes", %{conn: conn} do
      conn = get(conn, Routes.quote_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create quote" do
    test "renders quote when data is valid", %{conn: conn} do
      conn = post(conn, Routes.quote_path(conn, :create), quote: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.quote_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2010-04-17",
               "kind" => "some kind",
               "provider" => "some provider",
               "query_id" => 42,
               "rate" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.quote_path(conn, :create), quote: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update quote" do
    setup [:create_quote]

    test "renders quote when data is valid", %{conn: conn, quote: %Quote{id: id} = quote} do
      conn = put(conn, Routes.quote_path(conn, :update, quote), quote: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.quote_path(conn, :show, id))

      assert %{
               "id" => id,
               "date" => "2011-05-18",
               "kind" => "some updated kind",
               "provider" => "some updated provider",
               "query_id" => 43,
               "rate" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, quote: quote} do
      conn = put(conn, Routes.quote_path(conn, :update, quote), quote: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete quote" do
    setup [:create_quote]

    test "deletes chosen quote", %{conn: conn, quote: quote} do
      conn = delete(conn, Routes.quote_path(conn, :delete, quote))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.quote_path(conn, :show, quote))
      end
    end
  end

  defp create_quote(_) do
    quote = fixture(:quote)
    {:ok, quote: quote}
  end
end
