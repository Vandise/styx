defmodule Styx.SchemaRegistry.Definition.SchemaTest do
  use ExUnit.Case

  doctest Styx.SchemaRegistry.Definition.Schema

  defmodule StyxTest.Schema do
    use Styx.SchemaRegistry.Definition.Schema

    schema "edu.uwsp.banderson.styx" do
      required "username", :string
    end

  end

  describe "schema/2" do
    test "generates the topic namespace" do
      expected = "edu.uwsp.banderson.styx"
      assert StyxTest.Schema.namespace() == expected
    end

    test "generates the field attributes" do
      expected = %Styx.SchemaRegistry.Avro.Field{name: "username", type: :string}
      assert Enum.at(StyxTest.Schema.fields(), 0) == expected
    end
  end
end