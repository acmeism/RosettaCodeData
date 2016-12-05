defmodule Sort do
  def stooge_sort(list) do
    stooge_sort(List.to_tuple(list), 0, length(list)-1) |> Tuple.to_list
  end

  defp stooge_sort(tuple, i, j) do
    if (vj = elem(tuple, j)) < (vi = elem(tuple, i)) do
      tuple = put_elem(tuple,i,vj) |> put_elem(j,vi)
    end
    if j - i > 1 do
      t = div(j - i + 1, 3)
      tuple
      |> stooge_sort(i, j-t)
      |> stooge_sort(i+t, j)
      |> stooge_sort(i, j-t)
    else
      tuple
    end
  end
end

(for _ <- 1..20, do: :rand.uniform(20)) |> IO.inspect
|> Sort.stooge_sort |> IO.inspect
