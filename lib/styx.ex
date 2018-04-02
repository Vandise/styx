defmodule Styx do
  @moduledoc """
  Styx Data Pipeline Collector
  """

  @doc """
  Styx data collector

  ## Help

    ./styx

  """
  def main(_args) do
    boot()
  end

  def boot() do
    children = [
      %{
        id: Styx.Confluent.Server.Scheduler,
        start: {Styx.Confluent.Server.Scheduler, :start_link, []}
      }
    ]
    opts = [strategy: :one_for_one, name: Styx.Supervisor]
    Supervisor.start_link(children, opts)
    Styx.Confluent.Server.Scheduler.register_jobs()
  end
end
