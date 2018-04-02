defmodule Confluent.Server.CronTest do

  use ExUnit.Case
  import Crontab.CronExpression
  require Support.Workers.MockWorker

  describe "@cron" do
    test "is set on compile" do
      assert Support.Workers.MockWorker.cron() == ~e[* * * * * *]
    end
  end
end