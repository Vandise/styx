defmodule Styx.SchemaRegistry.Avro.Field do

  @doc """
  Value structure containing the name and data type.

  ## fields:
      name: String
      type: any valid avro type

      See: https://help.alteryx.com/9.5/Avro_Data_Types.htm
  """
  defstruct name: nil, type: nil

end