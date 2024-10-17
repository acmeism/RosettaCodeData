defmodule Vector do
  def dot_product({a1,a2,a3}, {b1,b2,b3}), do: a1*b1 + a2*b2 + a3*b3

  def cross_product({a1,a2,a3}, {b1,b2,b3}), do: {a2*b3 - a3*b2, a3*b1 - a1*b3, a1*b2 - a2*b1}

  def scalar_triple_product(a, b, c), do: dot_product(a, cross_product(b, c))

  def vector_triple_product(a, b, c), do: cross_product(a, cross_product(b, c))
end

a = {3, 4, 5}
b = {4, 3, 5}
c = {-5, -12, -13}

IO.puts "a = #{inspect a}"
IO.puts "b = #{inspect b}"
IO.puts "c = #{inspect c}"
IO.puts "a . b = #{inspect Vector.dot_product(a, b)}"
IO.puts "a x b = #{inspect Vector.cross_product(a, b)}"
IO.puts "a . (b x c) = #{inspect Vector.scalar_triple_product(a, b, c)}"
IO.puts "a x (b x c) = #{inspect Vector.vector_triple_product(a, b, c)}"
