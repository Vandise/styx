defmodule Styx.Server.WorkerTest do
  use ExUnit.Case
  import Mock

  alias Styx.Confluent.Schema.API, as: API
  alias Support.Workers.MockWorker, as: Worker

  test "server registers schema on link" do
    schema = Styx.Confluent.Schema.Avro.build_avro(
      Worker.namespace(),
      Worker.fields()
    )
    host = Styx.Confluent.Schema.Request.host()
    with_mock API, [register: fn(_host, _name, _schema) -> {:ok, 200} end] do
      Worker.start_link([])
      assert called API.register(
        host, Worker.namespace(), schema
      )
    end
  end
end