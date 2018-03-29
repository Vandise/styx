defmodule Confluent.Schema.RegistryTest do

  use ExUnit.Case
  require Support.Workers.MockWorker

  test "schema macro sets namespace" do
    assert Support.Workers.MockWorker.namespace() == "com.vandise.banderson"
  end

  test "schema macro sets schema name" do
    assert Support.Workers.MockWorker.schema_name() == Support.Workers.MockWorker
  end

  test "schema macro sets fields" do
    fields = [
      %{:name => "country", :type => [:string, "null"]},
      %{:name => "password", :type => :string},
      %{:name => "username", :type => :string}
    ]
    assert Support.Workers.MockWorker.fields() == fields
  end

  test "can build avro schema" do
    result = Styx.Confluent.Schema.Avro.build_avro(
      Support.Workers.MockWorker.namespace(),
      Support.Workers.MockWorker.fields()
    )
    assert result == %{fields: [%{name: "country", type: [:string, "null"]}, %{name: "password", type: :string}, %{name: "username", type: :string}], name: "com.vandise.banderson", namespace: "com.vandise.banderson", type: "record"}
  end

end