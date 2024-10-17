defmodule Proper do
  def divisors(1), do: []
  def divisors(n), do: [1 | divisors(2,n,:math.sqrt(n))] |> Enum.sort

  defp divisors(k,_n,q) when k>q, do: []
  defp divisors(k,n,q) when rem(n,k)>0, do: divisors(k+1,n,q)
  defp divisors(k,n,q) when k * k == n, do: [k | divisors(k+1,n,q)]
  defp divisors(k,n,q)                , do: [k,div(n,k) | divisors(k+1,n,q)]
end

defmodule Aliquot do
  def sequence(n, maxlen\\16, maxterm\\140737488355328)
  def sequence(0, _maxlen, _maxterm), do: "terminating"
  def sequence(n, maxlen, maxterm) do
    {msg, s} = sequence(n, maxlen, maxterm, [n])
    {msg, Enum.reverse(s)}
  end

  defp sequence(n, maxlen, maxterm, s) when length(s) < maxlen and n < maxterm do
    m = Proper.divisors(n) |> Enum.sum
    cond do
      m in s ->
        case {m, List.last(s), hd(s)} do
          {x,x,_} ->
            case length(s) do
              1 -> {"perfect", s}
              2 -> {"amicable", s}
              _ -> {"sociable of length #{length(s)}", s}
            end
          {x,_,x} -> {"aspiring", [m | s]}
          _       -> {"cyclic back to #{m}", [m | s]}
        end
      m == 0 -> {"terminating", [0 | s]}
      true -> sequence(m, maxlen, maxterm, [m | s])
    end
  end
  defp sequence(_, _, _, s), do: {"non-terminating", s}
end

Enum.each(1..10, fn n ->
  {msg, s} = Aliquot.sequence(n)
  :io.fwrite("~7w:~21s: ~p~n", [n, msg, s])
end)
IO.puts ""
[11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488, 15355717786080]
|> Enum.each(fn n ->
     {msg, s} = Aliquot.sequence(n)
     if n<10000000, do: :io.fwrite("~7w:~21s: ~p~n", [n, msg, s]),
                  else: :io.fwrite("~w: ~s: ~p~n", [n, msg, s])
   end)
