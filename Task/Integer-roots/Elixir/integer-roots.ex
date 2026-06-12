defmodule Integer_roots do
  def root(_, b) when b<2, do: b
  def root(a, b) do
    a1 = a - 1
    f = fn x -> (a1 * x + div(b, power(x, a1))) |> div(a) end
    c = 1
    d = f.(c)
    e = f.(d)
    until(c, d, e, f)
  end

  defp until(c, d, e, _) when c in [d, e], do: min(d, e)
  defp until(_, d, e, f), do: until(d, e, f.(e), f)

  defp power(_, 0), do: 1
  defp power(n, m), do: Enum.reduce(1..m, 1, fn _,acc -> acc*n end)

  def task do
    IO.puts root(3,8)
    IO.puts root(3,9)
    IO.puts "First 2,001 digits of the square root of two:"
    IO.puts root(2, 2 * power(100, 2000))
  end
end

Integer_roots.task
