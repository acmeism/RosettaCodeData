defmodule Greatest do
  def subseq_sum(list) do
    list_i = Enum.with_index(list)
    acc = {0, 0, length(list), 0, 0}
    {_,max,first,last,_} = Enum.reduce(list_i, acc, fn {elm,i},{curr,max,first,last,curr_first} ->
      if curr < 0 do
        if elm > max, do: {elm, elm, i,     i,    curr_first},
                    else: {elm, max, first, last, curr_first}
      else
        cur2 = curr + elm
        if cur2 > max, do: {cur2, cur2, curr_first, i, curr_first},
                     else: {cur2, max,  first,   last, curr_first}
      end
    end)
    {max, Enum.slice(list, first..last)}
  end
end
