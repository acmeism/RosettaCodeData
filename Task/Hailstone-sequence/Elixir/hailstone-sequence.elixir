defmodule Hailstone do
  require Integer

  def step(1)                        , do: 0
  def step(n) when Integer.is_even(n), do: div(n,2)
  def step(n)                        , do: n*3 + 1

  def sequence(n) do
    Stream.iterate(n, &step/1) |> Stream.take_while(&(&1 > 0)) |> Enum.to_list
  end

  def run do
    seq27 = sequence(27)
    len27 = length(seq27)
    repr = String.replace(inspect(seq27, limit: 4) <> inspect(Enum.drop(seq27,len27-4)), "][", ", ")
    IO.puts "Hailstone(27) has #{len27} elements: #{repr}"

    {len, start} = Enum.map(1..100_000, fn(n) -> {length(sequence(n)), n} end) |> Enum.max
    IO.puts "Longest sequence starting under 100000 begins with #{start} and has #{len} elements."
  end
end

Hailstone.run
