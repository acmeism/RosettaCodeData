defmodule Catalan do
  def cat(n), do: div( factorial(2*n), factorial(n+1) * factorial(n) )

  defp factorial(n), do: fac1(n,1)

  defp fac1(0, acc), do: acc
  defp fac1(n, acc), do: fac1(n-1, n*acc)

  def cat_r1(0), do: 1
  def cat_r1(n), do: Enum.sum(for i <- 0..n-1, do: cat_r1(i) * cat_r1(n-1-i))

  def cat_r2(0), do: 1
  def cat_r2(n), do: div(cat_r2(n-1) * 2 * (2*n - 1), n + 1)

  def test do
    range = 0..14
    :io.format "Directly:~n~p~n",            [(for n <- range, do: cat(n))]
    :io.format "1st recusive method:~n~p~n", [(for n <- range, do: cat_r1(n))]
    :io.format "2nd recusive method:~n~p~n", [(for n <- range, do: cat_r2(n))]
  end
end

Catalan.test
