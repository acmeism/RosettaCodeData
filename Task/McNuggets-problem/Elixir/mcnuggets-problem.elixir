defmodule Mcnugget do
  def solve(limit) do
    0..limit
    |> MapSet.new()
    |> MapSet.difference(
      for(
        x <- 0..limit,
        y <- 0..limit,
        z <- 0..limit,
        Integer.mod(x, 6) == 0,
        Integer.mod(y, 9) == 0,
        Integer.mod(z, 20) == 0,
        x + y + z <= limit,
        into: MapSet.new(),
        do: x + y + z
      )
    )
    |> Enum.max()
  end
end

Mcnugget.solve(100) |> IO.puts
