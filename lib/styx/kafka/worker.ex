#
# TODO: Unit Tests
#
defmodule Styx.Kafka.Worker do

  import Crontab.CronExpression
  require Logger

  @moduledoc """
  Handles the execution of workers

  Available functions:
     * execute/1
     * next_run/1

  ## Use:
    ```
      Styx.Kafka.Worker.execute Worker.Module.Name
    ```
  """

  @doc """
  Executes the perform() function on the worker
    acquires a Zookeeper lock on /jobs/module.name
  """
  def execute(m) do
    worker_process(m)
  end

  @doc """
  Gets the next scheduled time for the worker to run relative to now()
  """
  def next_run(m) do
    {:ok, t} = m.cron_schedule() |> Crontab.Scheduler.get_next_run_date(DateTime.utc_now() |> DateTime.to_naive)
    t
  end

  #
  # Worker perform() logic
  #   locks a zookeeper path
  #   checks if run is still needed from data in path
  #   process() is run
  #   sets the data to the current timestamp
  #

  defp next_run_dt(m) do
    {:ok, t} = next_run(m) |> DateTime.from_naive("Etc/UTC")
    t
  end

  defp worker_process(m) do
    Styx.Zookeeper.Register.path_name(m)
      |> Styx.Zookeeper.Server.try_lock(fn() -> worker_locked_process(m) end)
  end

  defp worker_locked_process(m) do
    dt_s = next_run_dt(m) |> DateTime.to_string
    Styx.Zookeeper.Register.set_data(m, dt_s, false)
      |> perform(m)
  end

  defp perform(:ok, m) do
    m.perform()
  end

  defp perform(:error, m) do
    Logger.error "Failed to run worker: #{m}"
  end
end