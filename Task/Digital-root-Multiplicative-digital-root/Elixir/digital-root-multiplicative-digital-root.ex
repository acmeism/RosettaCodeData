defmodule Digital do
  def mdroot(n), do: mdroot(n, 0)

  defp mdroot(n, persist) when n < 10, do: {n, persist}
  defp mdroot(n, persist), do: mdroot(product(n, 1), persist+1)

  defp product(0, prod), do: prod
  defp product(n, prod), do: product(div(n, 10), prod*rem(n, 10))

  def task1(data) do
    IO.puts "Number: MDR  MP\n======  ===  =="
    Enum.each(data, fn n ->
      {mdr, persist} = mdroot(n)
      :io.format "~6w:   ~w  ~2w~n", [n, mdr, persist]
    end)
  end

  def task2(m \\ 5) do
    IO.puts "\nMDR: [n0..n#{m-1}]\n===  ========"
    map = add_map(0, m, Map.new)
    Enum.each(0..9, fn i ->
      first = map[i] |> Enum.reverse |> Enum.take(m)
      IO.puts "  #{i}: #{inspect first}"
    end)
  end

  defp add_map(n, m, map) do
    {mdr, _persist} = mdroot(n)
    new_map = Map.update(map, mdr, [n], fn vals -> [n | vals] end)
    min_len = Map.values(new_map) |> Enum.map(&length(&1)) |> Enum.min
    if min_len < m, do: add_map(n+1, m, new_map),
                  else: new_map
  end
end

Digital.task1([123321, 7739, 893, 899998])
Digital.task2
