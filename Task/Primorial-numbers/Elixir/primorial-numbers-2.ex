defmodule Primorial do
  def first(n,primes) do
    s = 0..9 |> Stream.map(fn n -> Enum.at(primes,n) end)
    (0..n-1)
      |> Enum.map(fn a -> s
        |> Enum.take(a)
        |> Enum.reduce(1, fn b,c -> b*c end)
        |> format(a) end)
  end

  def numbers(lims,primes) do
    numbers(lims,primes,[])
  end

  def numbers([],_primes,vals) do
    vals
      |> Enum.reverse
      |> Enum.map(fn {m,n} -> str_fr(n,m) end)
  end

  def numbers([lim|lims],primes,vals) do
    numbers(lims,primes,[{lim,number_length(primes,lim)}] ++ vals)
  end

  defp number_length(primes,n) do
    primes
      |> Enum.take(n)
      |> Enum.reduce(fn a,b -> a * b end)
      |> Integer.to_string
      |> String.length
  end

  defp format(pri,i), do: IO.puts("Primorial #{i}: #{pri}")
  defp str_fr(pri,i), do: IO.puts("Primorial #{i} has length: #{pri}")
end
