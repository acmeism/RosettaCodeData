defmodule Constrain do
  def circle do
    range = -15..15
    r2 = 10*10..15*15
    all_points = for x <- range, y <- range, x*x+y*y in r2, do: {x,y}
    IO.puts "Precalculate: #{length(all_points)}"
    points = Enum.take_random(all_points, 100)
    Enum.each(range, fn x ->
      IO.puts Enum.map(range, fn y -> if {x,y} in points, do: "o ", else: "  " end)
    end)
  end
end

Constrain.circle
