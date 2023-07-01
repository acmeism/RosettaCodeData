defmodule RC do
  def fizzbuzz(limit \\ 100) do
    fizz = Stream.cycle(["", "", "Fizz"])
    buzz = Stream.cycle(["", "", "", "", "Buzz"])
    Stream.zip(fizz, buzz)
    |> Enum.take(limit)
    |> Enum.with_index
    |> Enum.each(fn {{f,b},i} ->
         IO.puts if f<>b=="", do: i+1, else: f<>b
       end)
  end
end

RC.fizzbuzz
