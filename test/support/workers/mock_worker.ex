defmodule Support.Workers.MockWorker do

  use Styx.Confluent.Schema.Registry
  use Styx.Confluent.Server.Worker
  use Styx.Server.Cron

  schedule ~e[* * * * * *]

  schema "styx.registry.accounts" do
    required "username", :string
    required "password", :string
    optional "country",  :string
  end

  def perform() do
    IO.puts "I'm performing Support.Workers.MockWorker"
  end
end