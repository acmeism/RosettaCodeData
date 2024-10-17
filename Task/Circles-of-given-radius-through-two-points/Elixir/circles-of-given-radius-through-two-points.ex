defmodule RC do
  def circle(p, p, r) when r>0.0 do
    raise ArgumentError, message: "Infinite number of circles, points coincide."
  end
  def circle(p, p, r) when r==0.0 do
    {px, py} = p
    [{px, py, r}]
  end
  def circle({p1x,p1y}, {p2x,p2y}, r) do
    {dx, dy} = {p2x-p1x, p2y-p1y}
    q = :math.sqrt(dx*dx + dy*dy)
    if q > 2*r do
      raise ArgumentError, message: "Distance of points > diameter."
    else
      {x3, y3} = {(p1x+p2x) / 2, (p1y+p2y) / 2}
      d = :math.sqrt(r*r - q*q/4)
      Enum.uniq([{x3 - d*dy/q, y3 + d+dx/q, r}, {x3 + d*dy/q, y3 - d*dx/q, r}])
    end
  end
end

data = [{{0.1234, 0.9876}, {0.8765, 0.2345}, 2.0},
        {{0.0000, 2.0000}, {0.0000, 0.0000}, 1.0},
        {{0.1234, 0.9876}, {0.1234, 0.9876}, 2.0},
        {{0.1234, 0.9876}, {0.8765, 0.2345}, 0.5},
        {{0.1234, 0.9876}, {0.1234, 0.9876}, 0.0}]

Enum.each(data, fn {p1, p2, r} ->
  IO.write "Given points:\n  #{inspect p1},\n  #{inspect p2}\n  and radius #{r}\n"
  try do
    circles = RC.circle(p1, p2, r)
    IO.puts "You can construct the following circles:"
    Enum.each(circles, fn circle -> IO.puts "  #{inspect circle}" end)
  rescue
    e in ArgumentError -> IO.inspect e
  end
  IO.puts ""
end)
