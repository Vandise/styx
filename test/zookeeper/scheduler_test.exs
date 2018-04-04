defmodule Styx.Zookeeper.SchedulerTest do
  use ExUnit.Case

  doctest Styx.Zookeeper.Scheduler

  describe "get_workers/0" do
    test "gets a list of worker modules" do
      expected = [Test.Support.Workers.MockWorker]
      assert Styx.Zookeeper.Scheduler.get_workers() == expected
    end
  end

  describe "get_workers/1" do
    test "filters a list of workers from a list" do
      expected = [Test.Support.Workers.MockWorker, Test.Support.Workers.AnotherWorker]
      assert Styx.Zookeeper.Scheduler.get_workers({:ok, expected}) == expected
    end
  end
end