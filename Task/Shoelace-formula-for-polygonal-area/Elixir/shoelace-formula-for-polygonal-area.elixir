def shoelace(points) do
  points
  |> Enum.reduce({0, List.last(points)}, fn {x1, y1}, {sum, {x0, y0}} ->
    {sum + (y0 * x1 - x0 * y1), {x1, y1}}
  end)
  |> elem(0)
  |> div(2)
end
