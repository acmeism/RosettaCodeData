iex(1)> Stream.iterate(1, &(&1+2)) |> Enum.take(10)
[1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
