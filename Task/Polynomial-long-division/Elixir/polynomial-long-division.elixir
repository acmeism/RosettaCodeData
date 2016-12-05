defmodule Polynomial do
  def division(_, []), do: raise ArgumentError, "denominator is zero"
  def division(_, [0]), do: raise ArgumentError, "denominator is zero"
  def division(f, g) when length(f) < length(g), do: {[0], f}
  def division(f, g) do
    {q, r} = division(g, [], f)
    if q==[], do: q = [0]
    if r==[], do: r = [0]
    {q, r}
  end

  defp division(g, q, r) when length(r) < length(g), do: {q, r}
  defp division(g, q, r) do
    p = hd(r) / hd(g)
    r2 = Enum.zip(r, g)
         |> Enum.with_index
         |> Enum.reduce(r, fn {{pn,pg},i},acc ->
              List.replace_at(acc, i, pn - p * pg)
            end)
    division(g, q++[p], tl(r2))
  end
end

[ { [1, -12, 0, -42], [1, -3] },
  { [1, -12, 0, -42], [1, 1, -3] },
  { [1, 3, 2],        [1, 1] },
  { [1, -4, 6, 5, 3], [1, 2, 1] } ]
|> Enum.each(fn {f,g} ->
     {q, r} = Polynomial.division(f, g)
     IO.puts "#{inspect f} / #{inspect g} => #{inspect q} remainder #{inspect r}"
   end)
