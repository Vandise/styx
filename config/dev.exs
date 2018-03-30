use Mix.Config

config :styx, Styx.Confluent.Schema.Registry,
  host: "http://192.168.99.100",
  port: 8081

config :kafka_ex,
  # a list of brokers to connect to in {"HOST", port} format
  brokers: [
    {"192.168.99.10", 9092}
  ]