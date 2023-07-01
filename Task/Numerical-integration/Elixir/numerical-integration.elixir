defmodule Numerical do
  @funs  ~w(leftrect midrect rightrect trapezium simpson)a

  def  leftrect(f, left,_right), do: f.(left)
  def   midrect(f, left, right), do: f.((left+right)/2)
  def rightrect(f,_left, right), do: f.(right)
  def trapezium(f, left, right), do: (f.(left)+f.(right))/2
  def   simpson(f, left, right), do: (f.(left) + 4*f.((left+right)/2.0) + f.(right)) / 6.0

  def integrate(f, a, b, steps) when is_integer(steps) do
    delta = (b - a) / steps
    Enum.each(@funs, fn fun ->
      total = Enum.reduce(0..steps-1, 0, fn i, acc ->
        left = a + delta * i
        acc + apply(Numerical, fun, [f, left, left+delta])
      end)
      :io.format "~10s : ~.6f~n", [fun, total * delta]
    end)
  end
end

f1 = fn x -> x * x * x end
IO.puts "f(x) = x^3, where x is [0,1], with 100 approximations."
Numerical.integrate(f1, 0, 1, 100)

f2 = fn x -> 1 / x end
IO.puts "\nf(x) = 1/x, where x is [1,100], with 1,000 approximations. "
Numerical.integrate(f2, 1, 100, 1000)

f3 = fn x -> x end
IO.puts "\nf(x) = x, where x is [0,5000], with 5,000,000 approximations."
Numerical.integrate(f3, 0, 5000, 5_000_000)

f4 = fn x -> x end
IO.puts "\nf(x) = x, where x is [0,6000], with 6,000,000 approximations."
Numerical.integrate(f4, 0, 6000, 6_000_000)
