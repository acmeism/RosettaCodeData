defmodule Prime do
  def conspiracy(m) do
    IO.puts "#{m} first primes. Transitions prime % 10 → next-prime % 10."
    Enum.map(prime(m), &rem(&1, 10))
    |> Enum.chunk(2,1)
    |> Enum.reduce(Map.new, fn [a,b],acc -> Map.update(acc, {a,b}, 1, &(&1+1)) end)
    |> Enum.sort
    |> Enum.each(fn {{a,b},v} ->
         sv = to_string(v) |> String.rjust(10)
         sf = Float.to_string(100.0*v/m, [decimals: 4])
         IO.puts "#{a} → #{b} count:#{sv} frequency:#{sf} %"
       end)
  end

  def prime(n) do
    max = n * :math.log(n * :math.log(n)) |> trunc      # from Rosser's theorem
    Enum.to_list(2..max)
    |> prime(:math.sqrt(max), [])
    |> Enum.take(n)
  end
  defp prime([h|t], limit, result) when h>limit, do: Enum.reverse(result, [h|t])
  defp prime([h|t], limit, result) do
    prime((for x <- t, rem(x,h)>0, do: x), limit, [h|result])
  end
end

Prime.conspiracy(1000000)
