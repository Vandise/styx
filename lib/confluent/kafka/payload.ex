defmodule Styx.Confluent.Kafka.Payload do

  def as_avro(schema_map, record) do
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