defmodule Styx.Confluent.Schema.Request do

  alias Styx.Confluent.Schema.API, as: API

  @cfg Application.fetch_env! :styx, Styx.Confluent.Schema.Registry

  def host do
    "#{@cfg[:host]}:#{@cfg[:port]}"
  end

  defp call(endpoint, payload) do
    apply API, endpoint, [ host() | payload ]
  end
end