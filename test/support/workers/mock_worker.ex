defmodule Support.Workers.MockWorker do

  use Styx.Confluent.Schema.Registry
  use Styx.Confluent.Server.Worker
  use Styx.Server.Cron

  schedule "*/15 * * * *"

  schema "styx.registry.accounts" do
    required "username", :string
    required "password", :string
    optional "country",  :string
  end
end