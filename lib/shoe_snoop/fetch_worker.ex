defmodule ShoeSnoop.FetchWorker do
  def start_link(opts = %{url: _, elem: _}) do
    state = Map.take(opts, [:url, :elem])
    GenServer.start_link(__MODULE__, state, name: {:via, Registry, {get_registry_name(), state}})
  end

  def init(state = %{}) do
    schedule_tick(0)
    {:ok, state}
  end

  def get_registry_name() do
    __MODULE__
  end

  def handle_info(:tick, state = %{url: url, elem: elem}) do
    IO.inspect("Processing url=#{url}")
    {element, ms, size, md5} = ShoeSnoop.YeezyFetch.fetch(url, elem)
    next_state = Map.merge(state, %{md5: md5, size: size})
    compare_results(state, next_state)
    schedule_tick(5_000)
    IO.inspect("Processed url=#{url} ms=#{ms} bytes=#{size} md5=#{md5}")
    {:noreply, next_state}
  end

  defp schedule_tick(timeout) do
    Process.send_after(self(), :tick, timeout)
  end

  defp compare_results(state = %{md5: old_md5, size: old_size}, %{md5: new_md5, size: new_size}) do
    if old_md5 != new_md5 or old_size != new_size do
      IO.inspect "GO GO GO"
    else
      IO.puts "Looking good"
    end
  end
  defp compare_results(_, _), do: nil
end
