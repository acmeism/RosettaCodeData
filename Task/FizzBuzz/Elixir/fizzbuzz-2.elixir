#!/usr/bin/env elixir
1..100 |> Enum.map(fn i ->
  cond do
    rem(i,3*5) == 0 -> "FizzBuzz"
    rem(i,3) == 0   -> "Fizz"
    rem(i,5) == 0   -> "Buzz"
    true            -> i
  end
end) |> Enum.each(fn i -> IO.puts i end)
