defmodule Styx.SchemaRegistry.Avro.Schema do

  defstruct type: nil, name: nil, namespace: nil, fields: nil

  def generate(namespace, fields, type \\ "record") do
    %Styx.SchemaRegistry.Avro.Schema{
      name: namespace,
      namespace: namespace,
      type: type,
      fields: fields
    }
  end
end