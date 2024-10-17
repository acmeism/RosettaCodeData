defmodule Prime do
  def sequence do
    Stream.iterate(2, &(&1+1)) |> Stream.filter(&is_prime/1)
  end

  def is_prime(2), do: true
  def is_prime(n) when n<2 or rem(n,2)==0, do: false
  def is_prime(n), do: is_prime(n,3)

  defp is_prime(n,k) when n<k*k, do: true
  defp is_prime(n,k) when rem(n,k)==0, do: false
  defp is_prime(n,k), do: is_prime(n,k+2)
end

IO.inspect Prime.sequence |> Enum.take(20)
