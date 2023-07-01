defmodule Prime do
  defp left_truncatable?(n, prime) do
    func = fn i when i<=9 -> 0
              i           -> to_string(i) |> String.slice(1..-1) |> String.to_integer end
    truncatable?(n, prime, func)
  end

  defp right_truncatable?(n, prime) do
    truncatable?(n, prime, fn i -> div(i, 10) end)
  end

  defp truncatable?(n, prime, trunc_func) do
    if to_string(n) |> String.match?(~r/0/),
      do:   false,
      else: trunc_loop(trunc_func.(n), prime, trunc_func)
  end

  defp trunc_loop(0, _prime, _trunc_func), do: true
  defp trunc_loop(n, prime, trunc_func) do
    if elem(prime,n), do: trunc_loop(trunc_func.(n), prime, trunc_func), else: false
  end

  def eratosthenes(limit) do            # descending order
    Enum.to_list(2..limit) |> sieve(:math.sqrt(limit), [])
  end

  defp sieve([h|_]=list, max, sieved) when h>max, do: Enum.reverse(list, sieved)
  defp sieve([h | t], max, sieved) do
    list = for x <- t, rem(x,h)>0, do: x
    sieve(list, max, [h | sieved])
  end

  defp prime_table(_, [], list), do: [false, false | list]
  defp prime_table(n, [n|t], list), do: prime_table(n-1, t,      [true|list])
  defp prime_table(n, prime, list), do: prime_table(n-1, prime, [false|list])

  def task(limit \\ 1000000) do
    prime = eratosthenes(limit)
    prime_tuple = prime_table(limit, prime, []) |> List.to_tuple
    left = Enum.find(prime, fn n -> left_truncatable?(n, prime_tuple) end)
    IO.puts "Largest left-truncatable prime : #{left}"
    right = Enum.find(prime, fn n -> right_truncatable?(n, prime_tuple) end)
    IO.puts "Largest right-truncatable prime: #{right}"
  end
end

Prime.task
