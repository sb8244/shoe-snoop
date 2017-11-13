defmodule ShoeSnoop.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Registry, [:unique, ShoeSnoop.FetchWorker.get_registry_name()]),
      supervisor(ShoeSnoop.FetchSupervisor, []),
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    ret = Supervisor.start_link(children, opts)

    ShoeSnoop.start_yeezy_fetchers

    ret
  end
end
