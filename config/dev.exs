use Mix.Config

config :styx, Styx.Zookeeper,
  namespace: Styx.Workers,
  namespace_depth: 2,
  host: "192.168.99.100",
  port: 2181

config :styx, Styx.SchemaRegistry,
  host: "http://192.168.99.100",
  port: 8081

config :kafka_ex,
  # a list of brokers to connect to in {"HOST", port} format
  brokers: [
    {"192.168.99.100", 9092}
  ]