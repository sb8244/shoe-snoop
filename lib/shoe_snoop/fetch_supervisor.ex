defmodule ShoeSnoop.FetchSupervisor do
  use Supervisor

  def get(url, elem, opts \\ []) do
    options = Keyword.merge([name: __MODULE__], opts)
    Supervisor.start_child(options[:name], [%{url: url, elem: elem}]) |> case do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
      err -> err
    end
  end

  def start_link(opts \\ []) do
    options = Keyword.merge([name: __MODULE__], opts)
    Supervisor.start_link(__MODULE__, [], name: options[:name])
  end

  def init([]) do
    children = [
      worker(ShoeSnoop.FetchWorker, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one, max_restarts: 3, max_seconds: 5)
  end
end
