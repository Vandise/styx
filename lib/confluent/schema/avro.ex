defmodule Styx.Confluent.Schema.Avro do

  @nulltype "null"

  defmacro build_schema(namespace, fields, type \\ "record") do
    quote do
      build_avro(unquote(namespace), unquote(fields), unquote(type))
    end
  end

  def build_avro(namespace, fields, type \\ "record") do
    %{
      type: type,
      name: namespace,
      namespace: namespace,
      fields: fields
    }
  end

  def build_field(mod, name, type, required = true) do
    Module.put_attribute(mod, :fields, %{ name: name, type: type })
  end

  def build_field(mod, name, type, required = false) do
    Module.put_attribute(mod, :fields, %{ name: name, type: [ type, @nulltype ] })
  end

  defmacro required(name, type) do
    quote do
      build_field __MODULE__, unquote(name), unquote(type), true
    end
  end

  defmacro optional(name, type) do
    quote do
      build_field __MODULE__, unquote(name), unquote(type), false
    end
  end
end