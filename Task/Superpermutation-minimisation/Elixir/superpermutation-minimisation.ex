defmodule Superpermutation do
  def minimisation(1), do: [1]
  def minimisation(n) do
    Enum.chunk(minimisation(n-1), n-1, 1)
    |> Enum.reduce({[],nil}, fn sub,{acc,last} ->
      if Enum.uniq(sub) == sub do
        i = if acc==[], do: 0, else: Enum.find_index(sub, &(&1==last)) + 1
        {acc ++ (Enum.drop(sub,i) ++ [n] ++ sub), List.last(sub)}
      else
        {acc, last}
      end
    end)
    |> elem(0)
  end
end

to_s = fn list -> Enum.map_join(list, &Integer.to_string(&1,16)) end
Enum.each(1..8, fn n ->
  result = Superpermutation.minimisation(n)
  :io.format "~3w: len =~8w : ", [n, length(result)]
  IO.puts if n<5, do: Enum.join(result),
                else: to_s.(Enum.take(result,20)) <> "...." <> to_s.(Enum.slice(result,-20..-1))
end)
