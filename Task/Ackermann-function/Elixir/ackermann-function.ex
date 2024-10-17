defmodule Ackermann do
  def ack(0, n), do: n + 1
  def ack(m, 0), do: ack(m - 1, 1)
  def ack(m, n), do: ack(m - 1, ack(m, n - 1))
end

Enum.each(0..3, fn m ->
  IO.puts Enum.map_join(0..6, " ", fn n -> Ackermann.ack(m, n) end)
end)
