defmodule RC do
  def sumMul(n, f) do
    n1 = div(n - 1, f)
    div(f * n1 * (n1 + 1), 2)
  end

  def sum35(n) do
    sumMul(n, 3) + sumMul(n, 5) - sumMul(n, 15)
  end
end

Enum.each(1..20, fn i ->
  n = round(:math.pow(10, i))
  IO.puts RC.sum35(n)
end)
