defmodule Styx.SchemaRegistry.Avro.Schema do

  @moduledoc """
  Builds an avro schema definition

  Available functions:
     * generate/3

  ## Use:
    ```
      Styx.SchemaRegistry.Avro.Schema.generate(namespace, [], "record")
    ```
  """

  defstruct type: nil, name: nil, namespace: nil, fields: nil

  @doc """
  generates an avro schema.
    returns %Styx.SchemaRegistry.Avro.Schema
  """
  def generate(namespace, fields, type \\ "record") do
    %Styx.SchemaRegistry.Avro.Schema{
      name: namespace,
      namespace: namespace,
      type: type,
      fields: fields
    }
  end
end