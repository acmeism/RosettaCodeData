defmodule Factorial do
  # Simple recursive function
  def fac(0), do: 1
  def fac(n) when n > 0, do: n * fac(n - 1)

  # Tail recursive function
  def fac_tail(0), do: 1
  def fac_tail(n), do: fac_tail(n, 1)
  def fac_tail(1, acc), do: acc
  def fac_tail(n, acc) when n > 1, do: fac_tail(n - 1, acc * n)

  # Tail recursive function with default parameter
  def fac_default(n, acc \\ 1)
  def fac_default(0, acc), do: acc
  def fac_default(n, acc) when n > 0, do: fac_default(n - 1, acc * n)

  # Using Enumeration features
  def fac_reduce(0), do: 1
  def fac_reduce(n) when n > 0, do: Enum.reduce(1..n, 1, &*/2)

  # Using Enumeration features with pipe operator
  def fac_pipe(0), do: 1
  def fac_pipe(n) when n > 0, do: 1..n |> Enum.reduce(1, &*/2)

end
