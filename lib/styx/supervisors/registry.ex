defmodule Styx.Supervisors.Registry do

  @moduledoc """
  Supervises the Styx registry
  """

  use Styx.Supervisors.Supervisor

  def start_link(opts) do
    Logger.debug("Starting Registry: #{@registry_key}")
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      supervisor(Registry, [:unique, @registry_key])
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end