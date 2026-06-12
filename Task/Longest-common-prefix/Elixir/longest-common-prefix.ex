defmodule LCP do
  @data [
    ["interspecies", "interstellar", "interstate"],
    ["throne", "throne"],
    ["throne", "dungeon"],
    ["throne", "", "throne"],
    ["cheese"],
    [""],
    [],
    ["prefix", "suffix"],
    ["foo", "foobar"]
  ]

  def main do
    Enum.each(@data, fn strs ->
      IO.puts("#{inspect(strs)} -> #{inspect(lcp(strs))}")
    end)
  end

  defp lcp( [] ), do: ""
  defp lcp(strs), do: Enum.reduce(strs, &lcp/2)

  defp lcp(xs, ys), do: lcp(xs, ys, "")

  defp lcp(<<x,xs>>, <<x,ys>>, pre), do: lcp(xs, ys, <<x,pre>>)
  defp lcp(       _,        _, pre), do: String.reverse(pre)
end
