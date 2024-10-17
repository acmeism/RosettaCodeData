defmodule Loops do
  def for_step(n, step) do
    IO.inspect Enum.take_every(1..n, step)
  end
end

Loops.for_step(20, 3)
