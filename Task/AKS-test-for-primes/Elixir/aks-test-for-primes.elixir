defmodule AKS do
  def iterate(f, x), do: fn -> [x | iterate(f, f.(x))] end

  def take(0, _lazy), do: []
  def take(n, lazy) do
    [value | next] = lazy.()
    [value | take(n-1, next)]
  end

  def pascal, do: iterate(fn row -> [1 | sum_adj(row)] end, [1])

  defp sum_adj([_] = l), do: l
  defp sum_adj([a, b | _] = row), do: [a+b | sum_adj(tl(row))]

  def show_binomial(row) do
    degree = length(row) - 1
    ["(x - 1)^",  to_char_list(degree), " =", binomial_rhs(row, 1, degree)]
  end

  defp show_x(0), do: ""
  defp show_x(1), do: "x"
  defp show_x(n), do: [?x, ?^ | to_char_list(n)]

  defp binomial_rhs([], _, _), do: []
  defp binomial_rhs([coef | coefs], sgn, exp) do
    signchar = if sgn > 0, do: ?+, else: ?-
    [0x20, signchar, 0x20, to_char_list(coef), show_x(exp) | binomial_rhs(coefs, -sgn, exp-1)]
  end

  def primerow(row, n), do: Enum.all?(row, fn coef -> (coef == 1) or (rem(coef, n) == 0) end)

  def main do
    for row <- take(8, pascal), do: IO.puts show_binomial(row)
    IO.write "\nThe primes upto 50: "
    IO.inspect for {row, n} <- Enum.zip(tl(tl(take(51, pascal))), 2..50), primerow(row, n), do: n
  end
end

AKS.main
