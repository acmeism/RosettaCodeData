defmodule Bell do
    def triangle(), do: Stream.iterate([1], fn l -> bell_row l, [List.last l] end)
    def numbers(), do: triangle() |> Stream.map(&List.first/1)

    defp bell_row([], r), do: Enum.reverse r
    defp bell_row([a|a_s], r = [r0|_]), do: bell_row(a_s, [a + r0|r])
end

:io.format "The first 15 bell numbers are ~p~n~n",
    [Bell.numbers() |> Enum.take(15)]

IO.puts "The 50th Bell number is #{Bell.numbers() |> Enum.take(50) |> List.last}"
IO.puts ""

IO.puts "THe first 10 rows of Bell's triangle:"
IO.inspect(Bell.triangle() |> Enum.take(10))
