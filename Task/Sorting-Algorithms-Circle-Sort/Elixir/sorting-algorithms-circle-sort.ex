defmodule Sort do
  def circle_sort(data) do
    List.to_tuple(data)
    |> circle_sort(0, length(data)-1)
    |> Tuple.to_list
  end

  defp circle_sort(data, lo, hi) do
    case circle_sort(data, lo, hi, 0) do
      {result, 0} -> result
      {result, _} -> circle_sort(result, lo, hi)
    end
  end

  defp circle_sort(data, lo, lo, swaps), do: {data, swaps}
  defp circle_sort(data, lo, hi, swaps) do
    mid = div(lo + hi, 2)
    {data, swaps} = do_circle_sort(data, lo, hi, swaps)
    {data, swaps} = circle_sort(data, lo, mid, swaps)
    circle_sort(data, mid+1, hi, swaps)
  end

  def do_circle_sort(data, lo, hi, swaps) when lo>=hi do
    if lo==hi and elem(data, lo) > elem(data, hi+1),
      do:   {swap(data, lo, hi+1), swaps+1},
      else: {data, swaps}
  end
  def do_circle_sort(data, lo, hi, swaps) do
    if elem(data, lo) > elem(data, hi),
      do:   do_circle_sort(swap(data, lo, hi), lo+1, hi-1, swaps+1),
      else: do_circle_sort(data, lo+1, hi-1, swaps)
  end

  defp swap(data, i, j) do
    vi = elem(data, i)
    vj = elem(data, j)
    data |> put_elem(i, vj) |> put_elem(j, vi)
  end
end

data = [6, 7, 8, 9, 2, 5, 3, 4, 1]
IO.puts "before sort: #{inspect data}"
IO.puts " after sort: #{inspect Sort.circle_sort(data)}"
