defmodule Styx.MixProject do
  use Mix.Project

  def project do
    [
      app: :styx,
      version: "0.1.0",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env),
      escript: [main_module: Styx],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :kafka_ex, :snappy]
    ]
  end

  defp elixirc_paths(:test), do: ["lib","test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:bypass, "~> 0.8", only: :test},
      {:ex_doc, "~> 0.14", only: :dev},
      {:mock, "~> 0.3.0", only: :test},
      {:kafka_ex, "~> 0.8.2"},
      {:snappy, git: "https://github.com/fdmanana/snappy-erlang-nif"}
    ]
  end
end
