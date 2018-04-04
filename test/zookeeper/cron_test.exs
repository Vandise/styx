defmodule Styx.Zookeeper.CronTest do
  use ExUnit.Case

  doctest Styx.Zookeeper.Cron

  import Crontab.CronExpression

  defmodule StyxTest.Cron do
    use Styx.Zookeeper.Cron
    
    cron ~e[* * * * * *]
  end

  describe "cron_schedule/0" do
    test "retrieves the cron attribute" do
      expected = ~e[* * * * * *]
      assert StyxTest.Cron.cron_schedule() == expected
    end
  end
end