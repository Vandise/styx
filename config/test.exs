use Mix.Config

config :styx, Styx.Zookeeper,
  namespace: Test.Support.Workers,
  namespace_depth: 3,
  host: "192.168.99.100",
  port: 2181

config :styx, Styx.Confluent.Schema.Registry,
  host: "http://192.168.99.100",
  port: 8081

config :kafka_ex,
  # a list of brokers to connect to in {"HOST", port} format
  brokers: [
    {"192.168.99.100", 9092}
  ]