defmodule Styx.Supervisors.Supervisor do
  @moduledoc """
  Shared functions and attributes between supervisors
  """

  @doc """
  Adds the registry key attribute
    * Adds find_process/2
    * Adds registry_key/0
  """
  defmacro __using__(_) do
    quote location: :keep do
      use Supervisor
      require Logger

      @registry_key Application.get_env(:styx, :registry_key)

      def find_process(reg_key, f_id) do
        {pid, _} = Registry.lookup(@registry_key, reg_key) |> List.first
        Supervisor.which_children(pid)
          |> Enum.filter( fn({id, pid, _, _}) -> id == f_id end)
          |> List.first
      end

      def registry_key() do
        @registry_key
      end
    end
  end
end