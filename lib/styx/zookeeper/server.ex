defmodule Styx.Zookeeper.Server do

  @moduledoc """
  Handles Zookeeper requests

  functions:
     * get_pid/0
     * try_lock/3
  Requires:
    * Styx.Supervisors.Confluent
  """

  alias Styx.Supervisors.Confluent, as: Confluent

  @doc """
  retrieves the Zookeeper PID
  """
  def get_pid() do
    {_, pid, _, _} = Confluent.find_process(Confluent.key(), ZK)
    pid
  end

  @doc """
  attempts a lock on the given path
  returns
    :ok,
    :error
  """
  def try_lock(path, callback, timeout \\ 5000) do
    try do
      Zookeeper.WriteLock.lock(get_pid(), path, timeout, fn -> callback.() end)
    catch
      :exit, _ -> :error
    end
  end
end