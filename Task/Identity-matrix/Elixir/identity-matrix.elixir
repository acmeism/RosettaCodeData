defmodule Matrix do
  def identity(n) do
    Enum.map(0..n-1, fn i ->
      for j <- 0..n-1, do: (if i==j, do: 1, else: 0)
    end)
  end
end

IO.inspect Matrix.identity(5)
