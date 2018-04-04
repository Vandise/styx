defmodule Styx.SchemaRegistry.Definition.ValueTest do
  use ExUnit.Case

  doctest Styx.SchemaRegistry.Definition.Value

  defmodule StyxTest.Values do
    use Styx.SchemaRegistry.Definition.Value

    required "username", :string
    optional "country",  :string

    def fields, do: @fields
  end

  describe "required/2" do
    test "generates a required field" do
      expected = %Styx.SchemaRegistry.Avro.Field{ name: "username", type: :string}
      assert Enum.at(StyxTest.Values.fields(), 1) == expected
    end
  end

  describe "optional/2" do
    test "generates an optional field" do
      expected = %Styx.SchemaRegistry.Avro.Field{ name: "country", type: [ :string, "null" ]}
      assert Enum.at(StyxTest.Values.fields(), 0) == expected
    end
  end
end