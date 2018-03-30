defmodule Styx.Server.Worker do

  defmacro __using__(_) do
    quote location: :keep do
      use GenServer
      require Logger

      defmodule State do
        defstruct server_name: __MODULE__
      end

      @server_name __MODULE__

      def server_name, do: @server_name

      # #
      #   GenServer worker defaults
      # #

      def start_link(_arg) do
        GenServer.start_link(__MODULE__, %State{}, name: @server_name)
      end

      def init(args) do
        Logger.info "Starting worker: #{@server_name}"
        __MODULE__.register()
        {:ok, args}
      end

      defoverridable [start_link: 1, init: 1]

    end
  end

end