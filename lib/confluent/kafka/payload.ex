defmodule Styx.Confluent.Kafka.Payload do

  @avro_ops %{ key: nil }

  defmodule Avro do

    def create(schema_map, record) do
      Poison.encode(schema_map)
        |> parse
        |> encode(record)
    end
  
    defp parse({:ok, schema_json} = result) do
      AvroEx.parse_schema schema_json 
    end
  
    defp encode({:ok, avro_schema} = result, record) do
      AvroEx.encode avro_schema, record 
    end
  end

  def emit_avro(topic, payload, schema, key \\ nil, opts \\ %KafkaEx.Protocol.Produce.Request{}) do
    value = Styx.Confluent.Kafka.Payload.Avro.create(schema, payload)
    #%KafkaEx.Protocol.Produce.Message{ key: key, value: payload }
  end
end