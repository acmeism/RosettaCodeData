defmodule Sieve do
  def primes_to(limit), do: sieve(Enum.to_list(2..limit))

  defp sieve([h|t]), do: [h|sieve(t -- for n <- 1..length(t), do: h*n)]
  defp sieve([]), do: []
end
