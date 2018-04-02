defmodule Styx.Confluent.Server.Scheduler do

  use Quantum.Scheduler, otp_app: :styx
  @cfg Application.fetch_env! :styx, Styx.Confluent.Server.Worker
  @depth 2

  def register_jobs() do
    with {:ok, list} <- :application.get_key(:styx, :modules) do
      list
        |> Enum.filter(& &1 |> Module.split |> Enum.take(@depth) == Module.split(@cfg[:namespace]))
        |> Enum.each(fn(m) -> apply(__MODULE__, :register_job, [m]) end)
    end
  end

  def register_job(m) do
    Styx.Confluent.Server.Scheduler.new_job()
      |> Quantum.Job.set_name(m.server_name())
      |> Quantum.Job.set_schedule(m.cron())
      |> Quantum.Job.set_task(fn -> m.perform() end)
      |> Styx.Confluent.Server.Scheduler.add_job()
  end
end