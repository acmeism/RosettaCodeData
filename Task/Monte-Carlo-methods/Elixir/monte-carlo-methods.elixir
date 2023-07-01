defmodule MonteCarlo do
  def pi(n) do
    count = Enum.count(1..n, fn _ ->
      x = :rand.uniform
      y = :rand.uniform
      :math.sqrt(x*x + y*y) <= 1
    end)
    4 * count / n
  end
end

Enum.each([1000, 10000, 100000, 1000000, 10000000], fn n ->
  :io.format "~8w samples: PI = ~f~n", [n, MonteCarlo.pi(n)]
end)
