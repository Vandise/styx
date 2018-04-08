defmodule Styx.SchemaRegistry.Request do

  @cfg Application.fetch_env! :styx, Styx.SchemaRegistry

  def host() do
    "#{@cfg[:host]}:#{@cfg[:port]}"
  end

end