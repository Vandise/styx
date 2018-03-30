defmodule Styx.Server.WorkerTest do
  use ExUnit.Case
  import Mock

  alias Styx.Confluent.Schema.API, as: API
  alias Support.Workers.MockWorker, as: Worker

  test "registers the module as the server name" do
    assert Worker.server_name == Support.Workers.MockWorker
  end

  test_with_mock "server registers schema on link", API,
    [register: fn(_host, _name, _schema) -> {:ok, 200} end] do
    schema = Styx.Confluent.Schema.Avro.build_avro(
      Worker.namespace(),
      Worker.fields()
    )
    host = Styx.Confluent.Schema.Request.host()
    Worker.start_link([])
    assert called API.register(
      host, Worker.namespace(), schema
    )
  end
end