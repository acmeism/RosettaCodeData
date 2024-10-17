defmodule Population do

  def count(n), do: count(<<n :: integer>>, 0)

  defp count(<<>>, acc), do: acc

  defp count(<<bit :: integer-1, rest :: bitstring>>, sum), do: count(rest, sum + bit)

  def evil?(n), do: n >= 0 and rem(count(n),2) == 0

  def odious?(n), do: n >= 0 and rem(count(n),2) == 1

end

IO.puts "Population count of the first thirty powers of 3:"
IO.inspect Stream.iterate(1, &(&1*3)) |> Enum.take(30) |> Enum.map(&Population.count(&1))
IO.puts "first thirty evil numbers:"
IO.inspect Stream.iterate(0, &(&1+1)) |> Stream.filter(&Population.evil?(&1)) |> Enum.take(30)
IO.puts "first thirty odious numbers:"
IO.inspect Stream.iterate(0, &(&1+1)) |> Stream.filter(&Population.odious?(&1)) |> Enum.take(30)
