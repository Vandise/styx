defmodule Styx.Confluent.Schema.Macros do

  defmacro send(argument_names \\ []) do
    quote do
      def send_to(endpoint, unquote_splicing(argument_names)) do
        call endpoint, [ unquote_splicing(argument_names) ]
      end
    end
  end

end