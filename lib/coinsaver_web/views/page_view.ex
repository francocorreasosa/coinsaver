defmodule CoinsaverWeb.PageView do
  use CoinsaverWeb, :view

  def format_price(price) do
    Number.Currency.number_to_currency(
      price / 100,
      [delimiter: ".", separator: ","]
    )
  end 

  def format_name(name) do
    case name do
      "cambiame" -> "Cambiame"
      "ofertacambioweb" -> "OfertaCambioWeb"
      "fortex" -> "Fortex"
      "bandes" -> "Bandes"
      "brou" -> "Banco República"
      "itau" -> "Banco Itaú"
      "aspen" -> "Cambio Aspen"
      "matriz" -> "Cambio Matriz"
      "cambilex" -> "Cambilex"
      "gales" -> "Gales"
      "bbva" -> "BBVA"
      name -> name
    end
  end
end
