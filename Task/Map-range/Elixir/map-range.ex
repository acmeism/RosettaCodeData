defmodule RC do
  def map_range(a1 .. a2, b1 .. b2, s) do
    b1 + (s - a1) * (b2 - b1) / (a2 - a1)
  end
end

Enum.each(0..10, fn s ->
  :io.format "~2w map to ~7.3f~n", [s, RC.map_range(0..10, -1..0, s)]
end)
