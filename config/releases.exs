import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
app_port = System.fetch_env!("APP_PORT")
app_hostname = System.fetch_env!("APP_HOSTNAME")
db_user = System.fetch_env!("DB_USER")
db_password = System.fetch_env!("DB_PASSWORD")
db_host = System.fetch_env!("DB_HOST")

config :coinsaver, CoinsaverWeb.Endpoint,
  http: [:inet6, port: String.to_integer(app_port)],
  secret_key_base: secret_key_base

config :coinsaver,
  app_port: app_port

config :coinsaver,
  app_hostname: app_hostname

# Configure your database
config :coinsaver, Coinsaver.Repo,
  username: db_user,
  password: db_password,
  database: "coinsaver_prod",
  hostname: db_host,
  pool_size: 10

