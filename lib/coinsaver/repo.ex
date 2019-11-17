defmodule Coinsaver.Repo do
  use Ecto.Repo,
    otp_app: :coinsaver,
    adapter: Ecto.Adapters.Postgres
end
