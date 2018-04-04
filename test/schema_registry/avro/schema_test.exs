defmodule Styx.SchemaRegistry.Avro.SchemaTest do
  use ExUnit.Case

  doctest Styx.SchemaRegistry.Avro.Schema

  describe "generate/3" do
    test "generates an avro schema definition" do
      fields = [
        %Styx.SchemaRegistry.Avro.Field{name: "username", type: :string},
        %Styx.SchemaRegistry.Avro.Field{name: "password", type: :string}
      ]
      expected = %Styx.SchemaRegistry.Avro.Schema{
        name: "edu.uwsp.banderson.styx",
        namespace: "edu.uwsp.banderson.styx",
        type: "record",
        fields: fields
      }
      assert Styx.SchemaRegistry.Avro.Schema.generate("edu.uwsp.banderson.styx", fields) == expected
    end
  end
end