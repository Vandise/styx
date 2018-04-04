defmodule Styx.Zookeeper.Cron do

  @moduledoc """
  Implements macros to generate the cron schedule

  Available macros:
     * cron/1

  ## Use:
    ```
      use Styx.Zookeeper.Cron
    
      cron ~e[* * * * * *]
    ```
  """
  defmacro __using__(_) do
    quote location: :keep do
      import Crontab.CronExpression
      import Styx.Zookeeper.Cron, only: [cron: 1]
      Module.register_attribute(__MODULE__, :cron_schedule, accumulate: false)
    end
  end

  @doc """
  Sets the cron_schedule attribute
  Adds cron_schedule() function
  """
  defmacro cron(cron) do
    quote do
      Module.put_attribute(__MODULE__, :cron_schedule, unquote(cron))
      Styx.Zookeeper.Cron.module_attributes()
    end
  end

  @doc """
  Defines the cron_schedule() function
  """
  defmacro module_attributes() do
    quote do
      def cron_schedule, do: @cron_schedule
    end
  end
end