defmodule Sort do
  def radix_sort(list), do: radix_sort(list, 10)

  def radix_sort([], _), do: []
  def radix_sort(list, base) do
    max = abs(Enum.max_by(list, &abs(&1)))
    sorted = radix_sort(list, base, max, 1)
    {minus, plus} = Enum.partition(sorted, &(&1<0))
    Enum.reverse(minus, plus)
  end

  defp radix_sort(list, _, max, m) when max<m, do: list
  defp radix_sort(list, base, max, m) do
    buckets = List.to_tuple(for _ <- 0..base-1, do: [])
    bucket2 = Enum.reduce(list, buckets, fn x,acc ->
      i = abs(x) |> div(m) |> rem(base)
      put_elem(acc, i, [x | elem(acc, i)])
    end)
    list2 = Enum.reduce(base-1..0, [], fn i,acc -> Enum.reverse(elem(bucket2, i), acc) end)
    radix_sort(list2, base, max, m*base)
  end
end

IO.inspect Sort.radix_sort([-4, 5, -26, 58, -990, 331, 331, 990, -1837, 2028])
