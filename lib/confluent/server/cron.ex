defmodule Styx.Server.Cron do

  defmacro __using__(_) do
    quote location: :keep do
      require Logger
      import Styx.Server.Cron, only: [schedule: 1]
      Module.register_attribute(__MODULE__, :cron, accumulate: false)
    end
  end

  defmacro schedule(cron) do
    register_cron(cron)
  end

  defp register_cron(cron) do
    quote do
      Module.put_attribute(__MODULE__, :cron, unquote(cron))
      
      def cron, do: @cron
    end
  end

end