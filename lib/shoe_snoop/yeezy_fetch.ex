defmodule ShoeSnoop.YeezyFetch do
  def fetch(url, elem) do
    {resp, ms} = timed_fetch(url)
    gzipped = gzipped?(resp)
    body = get_body(resp, gzipped)
    element = Floki.find(body, elem) |> Floki.raw_html
    md5 = :crypto.hash(:md5, element) |> Base.encode16

    {element, ms, byte_size(element), md5}
  end

  defp timed_fetch(url) do
    {time, result} = :timer.tc(fn -> fetch(url) end)
    {result, time / 1000}
  end

  defp fetch(url) do
    HTTPoison.get!(url, headers_to_make_adidas_happy(), follow_redirect: true)
  end

  defp gzipped?(%{headers: headers}) do
    Enum.any?(headers, fn {name, value} -> 
     :hackney_bstr.to_lower(name) == "content-encoding" && :hackney_bstr.to_lower(value) == "gzip"
    end)
  end

  defp get_body(%{body: body}, true), do: :zlib.gunzip(body)
  defp get_body(%{body: body}, false), do: body

  defp headers_to_make_adidas_happy do
    [
      {"Accept-Encoding", "gzip, deflate"},
      {"User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36"},
      {"Accept-Language", "en-US,en;q=0.8"},
      {"Cache-Control", "no-cache"},
      {"Connection", "keep-alive"},
    ]
  end
end
