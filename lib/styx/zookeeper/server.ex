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
  creates a path in Zookeeper
  """
  def create(path) do
    Zookeeper.Client.create(get_pid(), path)
  end

  @doc """
  sets data with the path in zookeeper
  """
  def set_data(path, data) do
    Zookeeper.Client.set(get_pid(), path, data)
  end

  @doc """
  gets data with the path in zookeeper
  """
  def get_data(path) do
    {:ok, {data, _stat}} = Zookeeper.Client.get(get_pid(), path, self())
    {:ok, data}
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
      :exit, s -> IO.puts(inspect(s)); :error
    end
  end
end