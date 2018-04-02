defmodule Confluent.Server.CronTest do

  use ExUnit.Case
  require Support.Workers.MockWorker

  describe "@cron" do
    test "is set on compile" do
      assert Support.Workers.MockWorker.cron() == "*/15 * * * *"
    end
  end
end