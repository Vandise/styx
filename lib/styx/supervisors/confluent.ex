defmodule Styx.Supervisors.Confluent do

  @moduledoc """
  Monitors Confluent-Related processes

  Processes:
     * Zookeeper
     * Styx.Zookeeper.Scheduler
  Requires:
    * Styx.Supervisors.Registry
  """

  use Styx.Supervisors.Supervisor
  @zk Application.fetch_env! :styx, Styx.Zookeeper

  def start_link(opts) do
    Logger.debug("Starting Confluent")
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      %{
        id: ZK,
        start: { Zookeeper.Client, :start_link, ["#{@zk[:host]}:#{@zk[:port]}"] }
      },
      %{
        id: Scheduler,
        start: { Styx.Zookeeper.Scheduler, :start_link, [] }
      }
    ]

    {:ok, pid} = Supervisor.init(children, strategy: :one_for_one)

    Registry.register(@registry_key, key(), pid)

    {:ok, pid}
  end

  @doc """
  Returns the key in which the supervisor PID is present
  """
  def key() do
    "ConfluentSupervisor"
  end
end