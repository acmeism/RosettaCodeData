defmodule Quadratic do
  def roots(a, b, c) do
    IO.puts "Roots of a quadratic function (#{a}, #{b}, #{c})"
    d = b * b - 4 * a * c
    a2 = a * 2
    cond do
      d > 0 ->
        sd = :math.sqrt(d)
        IO.puts "  the real roots are #{(- b + sd) / a2} and #{(- b - sd) / a2}"
      d == 0 ->
        IO.puts "  the single root is #{- b / a2}"
      true ->
        sd = :math.sqrt(-d)
        IO.puts "  the complex roots are #{- b / a2} +/- #{sd / a2}*i"
    end
  end
end

Quadratic.roots(1, -2, 1)
Quadratic.roots(1, -3, 2)
Quadratic.roots(1, 0, 1)
Quadratic.roots(1, -1.0e10, 1)
Quadratic.roots(1, 2, 3)
Quadratic.roots(2, -1, -6)
