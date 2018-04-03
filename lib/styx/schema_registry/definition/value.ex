defmodule Styx.SchemaRegistry.Definition.Value do

  @nulltype "null"

  #defmacro generate(namespace, fields, type \\ "record") do
  #  quote do
  #    build_schema unquote(namespace), unquote(fields), unquote(type)
  #  end
  #end

  #def build_schema(namespace, fields, type \\ "record") do
  #  %{
  #    type: type,
  #    name: namespace,
  #    namespace: namespace,
  #    fields: fields
  #  }
  #end

  defstruct name: @nulltype, type: @nulltype

  defmacro __using__(_) do
    quote location: :keep do
      import Styx.SchemaRegistry.Definition.Value
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
    end
  end

  defmacro required(name, type) do
    quote do
      field __MODULE__, unquote(name), unquote(type), true
    end
  end

  defmacro optional(name, type) do
    quote do
      field __MODULE__, unquote(name), unquote(type), false
    end
  end

  def field(mod, name, type, required = true) do
    Module.put_attribute(mod, :fields, %Styx.SchemaRegistry.Definition.Value{ name: name, type: type })
  end

  def field(mod, name, type, required = false) do
    Module.put_attribute(mod, :fields, %Styx.SchemaRegistry.Definition.Value{ name: name, type: [ type, @nulltype ] })
  end

end