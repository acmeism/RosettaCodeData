defmodule MutualRecursion do
  def f(0), do: 1
  def f(n), do: n - m(f(n - 1))
  def m(0), do: 0
  def m(n), do: n - f(m(n - 1))
end

IO.inspect Enum.map(0..19, fn n -> MutualRecursion.f(n) end)
IO.inspect Enum.map(0..19, fn n -> MutualRecursion.m(n) end)
