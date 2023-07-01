defmodule Permutation do
  def by_swap(n) do
    p = Enum.to_list(0..-n) |> List.to_tuple
    by_swap(n, p, 1)
  end

  defp by_swap(n, p, s) do
    IO.puts "Perm: #{inspect for i <- 1..n, do: abs(elem(p,i))}  Sign: #{s}"
    k = 0 |> step_up(n, p) |> step_down(n, p)
    if k > 0 do
      pk = elem(p,k)
      i = if pk>0, do: k+1, else: k-1
      p = Enum.reduce(1..n, p, fn i,acc ->
        if abs(elem(p,i)) > abs(pk), do: put_elem(acc, i, -elem(acc,i)), else: acc
      end)
      pi = elem(p,i)
      p = put_elem(p,i,pk) |> put_elem(k,pi)            # swap
      by_swap(n, p, -s)
    end
  end

  defp step_up(k, n, p) do
    Enum.reduce(2..n, k, fn i,acc ->
      if elem(p,i)<0 and abs(elem(p,i))>abs(elem(p,i-1)) and abs(elem(p,i))>abs(elem(p,acc)),
        do: i, else: acc
    end)
  end

  defp step_down(k, n, p) do
    Enum.reduce(1..n-1, k, fn i,acc ->
      if elem(p,i)>0 and abs(elem(p,i))>abs(elem(p,i+1)) and abs(elem(p,i))>abs(elem(p,acc)),
        do: i, else: acc
    end)
  end
end

Enum.each(3..4, fn n ->
  Permutation.by_swap(n)
  IO.puts ""
end)
