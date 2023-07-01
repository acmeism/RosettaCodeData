defmodule God do
  def g(n,g) when g == 1 or n < g, do: 1
  def g(n,g) do
    Enum.reduce(2..g, 1, fn q,res ->
      res + (if q > n-g, do: 0, else: g(n-g,q))
    end)
  end
end

Enum.each(1..25, fn n ->
  IO.puts Enum.map(1..n, fn g -> "#{God.g(n,g)} " end)
end)
