import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :counter, CounterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "PEUAGn/KJj9SltReXHKufgyAzlcbIIE3Ev1uQXMoW41Mecjx0LgDrmvMiKQ7Scgq",
  server: false

# In test we don't send emails.
config :counter, Counter.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
