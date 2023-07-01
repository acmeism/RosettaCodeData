defmodule RC do
  def factor(n), do: factor(n, 2, [])

  def factor(n, i, fact) when n < i*i, do: Enum.reverse([n|fact])
  def factor(n, i, fact) do
    if rem(n,i)==0, do: factor(div(n,i), i, [i|fact]),
                    else: factor(n, i+1, fact)
  end
end

Enum.each(1..20, fn n ->
  IO.puts "#{n}: #{Enum.join(RC.factor(n)," x ")}" end)
