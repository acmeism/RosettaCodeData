defmodule Sort do
  def comb_sort([]), do: []
  def comb_sort(input) do
    comb_sort(List.to_tuple(input), length(input), 0) |> Tuple.to_list
  end

  defp comb_sort(output, 1, 0), do: output
  defp comb_sort(input, gap, _) do
    gap = max(trunc(gap / 1.25), 1)
    {output,swaps} = Enum.reduce(0..tuple_size(input)-gap-1, {input,0}, fn i,{acc,swap} ->
      if (x = elem(acc,i)) > (y = elem(acc,i+gap)) do
        {acc |> put_elem(i,y) |> put_elem(i+gap,x), 1}
      else
        {acc,swap}
      end
    end)
    comb_sort(output, gap, swaps)
  end
end

(for _ <- 1..20, do: :rand.uniform(20)) |> IO.inspect |> Sort.comb_sort |> IO.inspect
