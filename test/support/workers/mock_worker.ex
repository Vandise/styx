defmodule Test.Support.Workers.MockWorker do

  use Styx.SchemaRegistry.Definition.Schema
  use Styx.Zookeeper.Cron
  
  cron ~e[* * * * * *]

  schema "styx.registry.accounts" do
    required "username", :string
    required "password", :string
    optional "country",  :string
  end

end