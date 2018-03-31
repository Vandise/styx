defmodule Styx.Confluent.Schema.Registry do

  defmacro __using__(_) do
    quote location: :keep do
      require Logger
      import Styx.Confluent.Schema.Avro
      import Styx.Confluent.Schema.Registry, only: [schema: 2, set_namespace: 1]

      @namespace nil
      @schema_name __MODULE__
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
    end
  end

  defmacro schema(namespace, [do: block]) do
    register_schema(namespace, block)
  end

  defmacro set_namespace(namespace) do
    quote do
      if @namespace == nil do
        @namespace unquote(namespace)
      end
    end
  end

  defp register_schema(namespace, block) do
    quote do
      import Styx.Confluent.Schema.Avro
      Styx.Confluent.Schema.Registry.set_namespace(unquote(namespace))

      try do
        unquote(block)
      after
        :ok
      end

      def fields, do: @fields
      def schema_name, do: @schema_name
      def namespace, do: @namespace

      def register do
        avro_schema = build_schema(@namespace, @fields)
        {status, _} = Styx.Confluent.Schema.API.register(
          Styx.Confluent.Schema.Request.host(), "#{@namespace}-value", avro_schema
        )
        if status == :ok, do: Logger.info("Schema #{@namespace}-value registered.")
      end

    end
  end

end