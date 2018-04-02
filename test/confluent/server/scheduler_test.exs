defmodule Styx.Confluent.Server.SchedulerTest do

  use ExUnit.Case
  import Mock
  require Styx.Confluent.Server.Scheduler

  describe "register_jobs/0" do
    test "server registers the mock worker" do
        Styx.Confluent.Server.Scheduler.register_jobs()
        assert Styx.Confluent.Server.Scheduler.find_job(:SupportWorkersMockWorker)
    end
  end
end