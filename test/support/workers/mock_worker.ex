defmodule Support.Workers.MockWorker do

  use Styx.Confluent.Schema.Registry

  schema "com.vandise.banderson" do
    required "username", :string
    required "password", :string
    optional "country",  :string
  end
end