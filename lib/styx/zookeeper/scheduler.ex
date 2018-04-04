defmodule Styx.Zookeeper.Scheduler do

  @moduledoc """
  Handles the scheduling of workers

  Available functions:
     * get_workers/0
     * get_workers/1
     * register_jobs/0
     * register_job/1

  ## Use:
    ```
      Styx.Zookeeper.Scheduler.start_link []
      Styx.Zookeeper.Scheduler.register_jobs()
    ```
  """

  use Quantum.Scheduler, otp_app: :styx
  @settings Application.fetch_env! :styx, Styx.Zookeeper

  defp module_list() do
    :application.get_key(:styx, :modules)
  end

  @doc """
  Filters out workers defined in the namespace setting
    Configured in: :styx, Styx.Zookeeper
  """
  def get_workers() do
    with {:ok, list} <- module_list() do
      get_workers list
    end
  end

  @doc """
  Filters out workers in a pre-defined list
  Takes in a list.
  """
  def get_workers(list) do
    Enum.filter(list, fn(m) ->
      Module.split(m) |> Enum.take(@settings[:namespace_depth]) == Module.split(@settings[:namespace])
    end)
  end

  @doc """
  Registers jobs from the application module list
  """
  def register_jobs() do
    with {:ok, list} <- module_list() do
      list
        |> get_workers
        |> Enum.each(fn(m) -> apply(__MODULE__, :register_job, [m]) end)
    end
  end

  @doc """
  Registers a module / job and adds it to the scheduler
  """
  def register_job(m) do
    new_job()
      |> Quantum.Job.set_name(m)
      |> Quantum.Job.set_schedule(m.cron_schedule())
      |> Quantum.Job.set_task(fn -> IO.puts "Running: #{m}" end)
      |> add_job()
  end
end