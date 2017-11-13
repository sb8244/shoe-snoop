defmodule ShoeSnoop do
  def start_yeezy_fetchers do
    ShoeSnoop.start_fetcher("https://yeezysupply.com", "body")
    ShoeSnoop.start_fetcher("http://www.adidas.com/yeezy", "body")
  end

  def start_fetcher(url, element) do
    ShoeSnoop.FetchSupervisor.get(url, element)
  end
end
