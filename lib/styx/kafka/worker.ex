#
# TODO: Unit Tests
#
defmodule Styx.Kafka.Worker do

  import Crontab.CronExpression

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
    path = "/jobs/#{m}"
    Styx.Zookeeper.Server.try_lock(path, fn() -> worker_lock_process(m, path) end)
  end

  defp worker_lock_process(m, path) do
    dt_s = next_run_dt(m) |> DateTime.to_string
    handle_data_update(path, m, Styx.Zookeeper.Server.set_data(path, dt_s))
    m.perform()
  end

  defp handle_data_update(path, m, {:error, :no_node}) do
    {:ok, _} = Styx.Zookeeper.Server.create(path)
    handle_data_update(path, m, true)
  end

  defp handle_data_update(path, m, _exists) do
    dt_s = next_run_dt(m) |> DateTime.to_string
    {:ok, _} = Styx.Zookeeper.Server.set_data(path, dt_s)
  end
end