defmodule Random do
  def randN(n) do
    if :rand.uniform(n) == 1, do: 1, else: 0
  end
  def unbiased(n) do
    {x, y} = {randN(n), randN(n)}
    if x != y, do: x, else: unbiased(n)
  end
end

IO.puts "N  biased  unbiased"
m = 10000
for n <- 3..6 do
  xs = for _ <- 1..m, do: Random.randN(n)
  ys = for _ <- 1..m, do: Random.unbiased(n)
  IO.puts "#{n}  #{Enum.sum(xs) / m}  #{Enum.sum(ys) / m}"
end
