defmodule Sort do
  def heapSort(list) do
    len = length(list)
    heapify(List.to_tuple(list), div(len - 2, 2))
    |> heapSort(len-1)
    |> Tuple.to_list
  end

  defp heapSort(a, finish) when finish > 0 do
    swap(a, 0, finish)
    |> siftDown(0, finish-1)
    |> heapSort(finish-1)
  end
  defp heapSort(a, _), do: a

  defp heapify(a, start) when start >= 0 do
    siftDown(a, start, tuple_size(a)-1)
    |> heapify(start-1)
  end
  defp heapify(a, _), do: a

  defp siftDown(a, root, finish) when root * 2 + 1 <= finish do
    child = root * 2 + 1
    if child + 1 <= finish and elem(a,child) < elem(a,child + 1), do: child = child + 1
    if elem(a,root) < elem(a,child),
      do:   swap(a, root, child) |> siftDown(child, finish),
      else: a
  end
  defp siftDown(a, _root, _finish), do: a

  defp swap(a, i, j) do
    {vi, vj} = {elem(a,i), elem(a,j)}
    a |> put_elem(i, vj) |> put_elem(j, vi)
  end
end

(for _ <- 1..20, do: :rand.uniform(20)) |> IO.inspect |> Sort.heapSort |> IO.inspect
