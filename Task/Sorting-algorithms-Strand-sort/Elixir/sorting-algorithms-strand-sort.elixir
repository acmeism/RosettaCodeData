defmodule Sort do
  def strand_sort(args), do: strand_sort(args, [])

  defp strand_sort([], result), do: result
  defp strand_sort(a, result) do
    {_, sublist, b} = Enum.reduce(a, {hd(a),[],[]}, fn val,{v,l1,l2} ->
                        if v <= val, do: {val, [val | l1], l2},
                                   else: {v,   l1, [val | l2]}
                      end)
    strand_sort(b, :lists.merge(Enum.reverse(sublist), result))
  end
end

IO.inspect Sort.strand_sort [7, 17, 6, 20, 20, 12, 1, 1, 9]
