defmodule Random do
  defp generate_point(0, _, _, set), do: set
  defp generate_point(n, f, condition, set) do
    point = {x,y} = {f.(), f.()}
    if x*x + y*y in condition and not point in set,
      do:   generate_point(n-1, f, condition, MapSet.put(set, point)),
      else: generate_point(n,   f, condition, set)
  end

  def circle do
    f = fn -> :rand.uniform(31) - 16 end
    points = generate_point(100, f, 10*10..15*15, MapSet.new)
    range = -15..15
    for x <- range do
      for y <- range do
        IO.write if {x,y} in points, do: "x", else: " "
      end
      IO.puts ""
    end
  end
end

Random.circle
