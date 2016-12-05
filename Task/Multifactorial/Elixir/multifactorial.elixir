defmodule RC do
  def multifactorial(n,d) do
    Enum.take_every(n..1, d) |> Enum.reduce(1, fn x,p -> x*p end)
  end
end

Enum.each(1..5, fn d ->
  multifac = for n <- 1..10, do: RC.multifactorial(n,d)
  IO.puts "Degree #{d}: #{inspect multifac}"
end)
