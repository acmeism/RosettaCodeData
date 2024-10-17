defmodule Prime do
  def eratosthenes(limit \\ 1000) do
    sieve = [false, false | Enum.to_list(2..limit)] |> List.to_tuple
    check_list = [2 | Stream.iterate(3, &(&1+2)) |> Enum.take(round(:math.sqrt(limit)/2))]
    Enum.reduce(check_list, sieve, fn i,tuple ->
      if elem(tuple,i) do
        clear_num = Stream.iterate(i*i, &(&1+i)) |> Enum.take_while(fn x -> x <= limit end)
        clear(tuple, clear_num)
      else
        tuple
      end
    end)
  end

  defp clear(sieve, list) do
    Enum.reduce(list, sieve, fn i, acc -> put_elem(acc, i, false) end)
  end
end

limit = 199
sieve = Prime.eratosthenes(limit)
Enum.each(0..limit, fn n ->
  if x=elem(sieve, n), do: :io.format("~3w", [x]), else: :io.format("  .")
  if rem(n+1, 20)==0, do: IO.puts ""
end)
