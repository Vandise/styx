defmodule Confluent.Kafka.PayloadTest do

  use ExUnit.Case
  require Support.Workers.MockWorker

  test "can create an avro payload" do
    schema = Styx.Confluent.Schema.Avro.build_avro(
      Support.Workers.MockWorker.namespace(),
      Support.Workers.MockWorker.fields()
    )
    record = %{
      "username" => "required",
      "password" => "required",
      "country" => "optional"
    }
    {:ok, payload} = Styx.Confluent.Kafka.Payload.as_avro(schema, record)
    assert payload == <<0, 16, 111, 112, 116, 105, 111, 110, 97, 108, 16, 114, 101, 113, 117, 105, 114, 101, 100, 16, 114, 101, 113, 117, 105, 114, 101, 100>>
  end

end