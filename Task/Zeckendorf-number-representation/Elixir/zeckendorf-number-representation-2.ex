defmodule Zeckendorf do
  def number(n) do
    fib_loop(n, [2,1])
    |> Enum.reduce({"",n}, fn f,{dig,i} ->
         if f <= i, do: {dig<>"1", i-f}, else: {dig<>"0", i}
       end)
    |> elem(0) |> String.to_integer
  end

  defp fib_loop(n, fib) when n < hd(fib), do: fib
  defp fib_loop(n, [a,b|_]=fib), do: fib_loop(n, [a+b | fib])
end

for i <- 0..20, do: IO.puts "#{i}: #{Zeckendorf.number(i)}"
