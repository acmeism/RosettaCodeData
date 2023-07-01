defmodule Catalan do
  def numbers(num) do
    {result,_} = Enum.reduce(1..num, {[],{0,1}}, fn i,{list,t0} ->
      t1 = numbers(i, t0)
      t2 = numbers(i+1, Tuple.insert_at(t1, i+1, elem(t1, i)))
      {[elem(t2, i+1) - elem(t2, i) | list], t2}
    end)
    Enum.reverse(result)
  end

  defp numbers(0, t), do: t
  defp numbers(n, t), do: numbers(n-1, put_elem(t, n, elem(t, n-1) + elem(t, n)))
end

IO.inspect Catalan.numbers(15)
