defmodule Styx.SchemaRegistry.Definition.Schema do

  @moduledoc """
  Implements macros to generate an avro schema

  Available macros:
     * schema/2
     * set_namespace/1

  ## Use:
    ```
      use Styx.SchemaRegistry.Definition.Schema
    
      schema "edu.uwsp.banderson.styx" do
        required :username, :string
        optional :age, :boolean
      end
    ```
  """

  @doc """
  Adds the schema and set_namespace macros.
    * Uses Styx.SchemaRegistry.Definition.Value
    * Sets @namespace to nil
  """
  defmacro __using__(_) do
    quote location: :keep do
      use Styx.SchemaRegistry.Definition.Value
      import Styx.SchemaRegistry.Definition.Schema, only: [schema: 2, set_namespace: 1]
      @namespace nil
    end
  end

  @doc """
  sets @namespace if it has not already been set
  """
  defmacro set_namespace(namespace) do
    quote do
      if @namespace == nil do
        @namespace unquote(namespace)
      end
    end
  end

  @doc """
  sets @namespace, evaluates the fields block if given
  """
  defmacro schema(namespace, [do: block]) do
    quote do
      set_namespace(unquote(namespace))
      try do
        unquote(block)
      after
        :ok
      end
    end
  end
end