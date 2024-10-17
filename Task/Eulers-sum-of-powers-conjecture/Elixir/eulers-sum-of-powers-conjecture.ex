defmodule Euler do
  def sum_of_power(max \\ 250) do
    {p5, sum2} = setup(max)
    sk = Enum.sort(Map.keys(sum2))
    Enum.reduce(Enum.sort(Map.keys(p5)), Map.new, fn p,map ->
      sum(sk, p5, sum2, p, map)
    end)
  end

  defp setup(max) do
    Enum.reduce(1..max, {%{}, %{}}, fn i,{p5,sum2} ->
      i5 = i*i*i*i*i
      add = for j <- i..max, into: sum2, do: {i5 + j*j*j*j*j, [i,j]}
      {Map.put(p5, i5, i), add}
    end)
  end

  defp sum([], _, _, _, map), do: map
  defp sum([s|_], _, _, p, map) when p<=s, do: map
  defp sum([s|t], p5, sum2, p, map) do
    if sum2[p - s],
      do:   sum(t, p5, sum2, p, Map.put(map, Enum.sort(sum2[s] ++ sum2[p-s]), p5[p])),
      else: sum(t, p5, sum2, p, map)
  end
end

Enum.each(Euler.sum_of_power, fn {k,v} ->
  IO.puts Enum.map_join(k, " + ", fn i -> "#{i}**5" end) <> " = #{v}**5"
end)
