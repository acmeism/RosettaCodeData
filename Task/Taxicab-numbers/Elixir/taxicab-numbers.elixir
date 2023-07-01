defmodule Taxicab do
  def numbers(n \\ 1200) do
    (for i <- 1..n, j <- i..n, do: {i,j})
    |> Enum.group_by(fn {i,j} -> i*i*i + j*j*j end)
    |> Enum.filter(fn {_,v} -> length(v)>1 end)
    |> Enum.sort
  end
end

nums = Taxicab.numbers |> Enum.with_index
Enum.each(nums, fn {x,i} ->
  if i in 0..24 or i in 1999..2005 do
    IO.puts "#{i+1} : #{inspect x}"
  end
end)
