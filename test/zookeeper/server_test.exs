defmodule Styx.Zookeeper.ServerTest do
  use ExUnit.Case

  doctest Styx.Zookeeper.Server

  defmodule Hello do
  
    def fast_process do
      :timer.sleep(100)
    end
  
    def slow_process do
      :timer.sleep(15000)
    end
  
  end

  describe "get_pid/0" do
    test "gets the process PID" do
      assert is_pid Styx.Zookeeper.Server.get_pid()
    end
  end

  describe "try_lock/3" do
    test "returns :ok on success" do
      status = Styx.Zookeeper.Server.try_lock("/hello", &Hello.fast_process/0, 1000)
      assert status == :ok
    end

    test "returns :error when lock cannot be retrieved" do
      spawn(fn -> Styx.Zookeeper.Server.try_lock("/hello", &Hello.slow_process/0) end)
      :timer.sleep(10)
      status = Styx.Zookeeper.Server.try_lock("/hello", &Hello.fast_process/0, 1000)
      assert status == :error
    end
  end
end