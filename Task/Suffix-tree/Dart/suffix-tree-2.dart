defmodule STree do
  defstruct branch: []

  defp suffixes([]), do: []
  defp suffixes(w), do: [w | suffixes tl(w)]

  defp lcp([], _, acc), do: acc
  defp lcp(_, [], acc), do: acc
  defp lcp([c | u], [a | w], acc) do
    if c == a do
      lcp(u, w, acc + 1)
    else acc
    end
  end

  defp g([], aw), do: [{{aw, length aw}, nil}]
  defp g(cusnes, aw) do
    [cusn | es] = cusnes
    {cus, node} = cusn
    {cu, culen} = cus
    cpl = case node do
      nil -> lcp cu, aw, 0
      _   -> lcp (Enum.take cu, culen), aw, 0
    end
    x = Enum.drop cu, cpl
    xlen = culen - cpl
    y = Enum.drop aw, cpl
    ex = {{x, xlen}, node}
    ey = {{y, length y}, nil}
    cond do
      hd(aw) > hd(cu)          -> [cusn | g(es, aw)]
      hd(aw) < hd(cu)          -> [{{aw, length aw}, nil} | cusnes]
      nil != node && xlen == 0 -> [{cus, insert_suffix(y, node)} | es]
      hd(x) < hd(y)            -> [{{cu, cpl}, %STree{branch: [ex, ey]}} | es]
      true                     -> [{{cu, cpl}, %STree{branch: [ey, ex]}} | es]
    end
  end

  defp insert_suffix(aw, node), do: %STree{branch: g(node.branch, aw)}

  def naive_insertion(t), do: List.foldl(suffixes(t), %STree{}, &insert_suffix/2)

  defp f(nil, _, label), do: IO.puts("╴ #{label}")
  defp f(%STree{branch: children}, pre, label) do
    IO.puts "┐ #{label}"
    children
    |> Enum.take(length(children) - 1)
    |> Enum.each(fn c ->
      IO.write(pre <> "├─")
      {ws, len} = elem(c, 0)
      f(elem(c, 1), pre <> "│ ", Enum.join(Enum.take ws, len))
    end)
    IO.write(pre <> "└─")
    c = List.last(children)
    {ws, len} = elem(c, 0)
    f(elem(c, 1), pre <> "  ", Enum.join(Enum.take ws, len))
  end

  def visualize(n), do: f(n, "", "")

  def main do
    "banana$"
    |> String.graphemes
    |> naive_insertion
    |> visualize
  end
end
