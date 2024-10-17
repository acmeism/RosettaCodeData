defmodule First_class_functions do
  def task(val) do
    as = [&:math.sin/1, &:math.cos/1, fn x -> x * x * x end]
    bs = [&:math.asin/1, &:math.acos/1, fn x -> :math.pow(x, 1/3) end]
    Enum.zip(as, bs)
    |> Enum.each(fn {a,b} -> IO.puts compose([a,b], val) end)
  end

  defp compose(funs, x) do
    Enum.reduce(funs, x, fn f,acc -> f.(acc) end)
  end
end

First_class_functions.task(0.5)
