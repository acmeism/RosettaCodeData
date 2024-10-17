defmodule CFrac do
  def compute([a | _], []), do: a
  def compute([a | as], [b | bs]), do: a + b/compute(as, bs)

  def sqrt2 do
    a = [1 | Stream.cycle([2]) |> Enum.take(1000)]
    b = Stream.cycle([1]) |> Enum.take(1000)
    IO.puts compute(a, b)
  end

  def exp1 do
    a = [2 | Stream.iterate(1, &(&1 + 1)) |> Enum.take(1000)]
    b = [1 | Stream.iterate(1, &(&1 + 1)) |> Enum.take(999)]
    IO.puts compute(a, b)
  end

  def pi do
    a = [3 | Stream.cycle([6]) |> Enum.take(1000)]
    b = 1..1000 |> Enum.map(fn k -> (2*k - 1)**2 end)
    IO.puts compute(a, b)
  end
end
