defmodule RC do
  def is_prime(2), do: true
  def is_prime(n) when n<2 or rem(n,2)==0, do: false
  def is_prime(n), do: is_prime(n,3)

  def is_prime(n,k) when n<k*k, do: true
  def is_prime(n,k) when rem(n,k)==0, do: false
  def is_prime(n,k), do: is_prime(n,k+2)
end

IO.inspect for n <- 1..50, RC.is_prime(n), do: n
