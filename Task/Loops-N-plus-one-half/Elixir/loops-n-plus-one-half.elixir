defmodule Loops do
  def n_plus_one_half([]), do: IO.puts ""
  def n_plus_one_half([x]), do: IO.puts x
  def n_plus_one_half([h|t]) do
    IO.write "#{h}, "
    n_plus_one_half(t)
  end
end

Enum.to_list(1..10) |> Loops.n_plus_one_half
