defmodule Styx.SchemaRegistry.Definition.Value do

  @nulltype "null"

  @moduledoc """
  Implements macros to generate required and optional fields

  Available macros:
     * required/2
     * optional/2

  ## Use:
    ```
      use Styx.SchemaRegistry.Definition.Value
    
      required :username, :string
      optional :age, :boolean
    ```
  """

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

  @doc """
  Value structure containing the name and data type.

  ## fields:
      name: String
      type: any valid avro type

      See: https://help.alteryx.com/9.5/Avro_Data_Types.htm
  """
  defstruct name: @nulltype, type: @nulltype

  @doc """
  Adds the fields attribute and imports the field functions
  """
  defmacro __using__(_) do
    quote location: :keep do
      import Styx.SchemaRegistry.Definition.Value
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
    end
  end

  @doc """
  Creates a required field and adds it to the fields attribute array
  
  ## Example:
    ```
      use Styx.SchemaRegistry.Definition.Value
      required :username, :string
      
      fields()
        => [ %Styx.SchemaRegistry.Definition.Value{ name: :username, type: :string } ]
    ```
  """
  defmacro required(name, type) do
    quote do
      field __MODULE__, unquote(name), unquote(type), true
    end
  end

  @doc """
  Creates a optional field and adds it to the fields attribute array
  
  ## Example:
    ```
      use Styx.SchemaRegistry.Definition.Value
      optional :country, :string
      
      def fields, do: @fields

      fields()
        => [ %Styx.SchemaRegistry.Definition.Value{ name: :country, type: [:string, "null"] } ]
    ```
  """
  defmacro optional(name, type) do
    quote do
      field __MODULE__, unquote(name), unquote(type), false
    end
  end


  @doc """
  Creates a required field and adds it to the fields attribute array
  
  ## Example:
    ```
      use Styx.SchemaRegistry.Definition.Value
      field(__MODULE__, :country, :string, true)
      
      def fields, do: @fields

      fields()
        => [ %Styx.SchemaRegistry.Definition.Value{ name: :country, type: :string } ]
    ```
  """
  defmacro field(mod, name, type, true) do
    quote do
      Module.put_attribute(unquote(mod), :fields, %Styx.SchemaRegistry.Definition.Value{ name: unquote(name), type: unquote(type) })
    end
  end

  @doc """
  Creates an optional field and adds it to the fields attribute array
  
  ## Example:
    ```
      use Styx.SchemaRegistry.Definition.Value
      field(__MODULE__, :country, :string, false)
      
      def fields, do: @fields

      fields()
        => [ %Styx.SchemaRegistry.Definition.Value{ name: :country, type: [:string, "null"] } ]
    ```
  """
  defmacro field(mod, name, type, false) do
    quote do
      Module.put_attribute(unquote(mod), :fields, %Styx.SchemaRegistry.Definition.Value{ name: unquote(name), type: [ unquote(type), unquote(@nulltype) ] })
    end
  end

end