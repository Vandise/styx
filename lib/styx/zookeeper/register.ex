defmodule Styx.Zookeeper.Register do

  @moduledoc """
  Handles the registration of data in Zookeeper

  Available functions:
     * create/1
  """

  require Logger


  # Locks the path for data updates


  defp lock(path, callback) do
    Styx.Zookeeper.Server.try_lock(path, callback)
      |> lock_result
  end

  defp lock_result(:error) do
    Logger.warn "Unable to get Zookeeper lock"
  end

  defp lock_result(_) do
    Logger.debug "Next run registered in Zookeeper"
  end


  # Path creation


  defp register_path_result({:ok, _}, path) do
    Logger.debug "#{path} registered in Zookeeper"
    :ok
  end

  defp register_path_result({_, status}, path) do
    Logger.warn "Failed to create #{path} in Zookeeper - #{status}"
    :error
  end

  defp register_path(path) do
    register_path_result Styx.Zookeeper.Server.create(path), path
  end


  # Data path sets


  defp register_data(path, data) do
    Styx.Zookeeper.Server.set_data(path, data)
      |> register_data_result(path)
  end

  defp register_data_result({:ok, _}, path) do
    Logger.debug "#{path}: Data registered in Zookeeper"
    :ok
  end

  defp register_data_result(_, path) do
    Logger.warn "#{path}: Failed to register data in Zookeeper"
    :error
  end

  # public functions


  def path_name(m) do
    "/jobs/#{m}"
  end

  @doc """
  Creates a new path in Zookeeper
    /jobs/Module.Name
  """
  def create_path(m, needs_lock \\ false) do
    path = path_name(m)
    if needs_lock do
      lock(path, fn -> register_path(path) end)
    else
      register_path(path)
    end
  end

  @doc """
  Sets data in Zookeeper
    /jobs/Module.Name
  """
  def set_data(m, data, needs_lock \\ true) do
    path = path_name(m)
    if needs_lock do
      lock(path, fn -> register_data(path, data) end)
    else
      register_data(path, data)
    end 
  end
end