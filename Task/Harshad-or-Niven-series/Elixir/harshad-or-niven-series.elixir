defmodule Harshad do
  def series, do: Stream.iterate(1, &(&1+1)) |> Stream.filter(&(number?(&1)))

  def number?(n), do: rem(n, digit_sum(n, 0)) == 0

  defp digit_sum(0, sum), do: sum
  defp digit_sum(n, sum), do: digit_sum(div(n, 10), sum + rem(n, 10))
end

IO.inspect Harshad.series |> Enum.take(20)

IO.inspect Harshad.series |> Stream.drop_while(&(&1 <= 1000)) |> Enum.take(1) |> hd
