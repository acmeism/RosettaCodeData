defmodule Ethiopian do
  def halve(n), do: div(n, 2)

  def double(n), do: n * 2

  def even(n), do: rem(n, 2) == 0

  def multiply(lhs, rhs) when is_integer(lhs) and lhs > 0 and is_integer(rhs) and rhs > 0 do
    multiply(lhs, rhs, 0)
  end

  def multiply(1, rhs, acc), do: rhs + acc
  def multiply(lhs, rhs, acc) do
    if even(lhs), do:   multiply(halve(lhs), double(rhs), acc),
                  else: multiply(halve(lhs), double(rhs), acc+rhs)
  end
end

IO.inspect Ethiopian.multiply(17, 34)
