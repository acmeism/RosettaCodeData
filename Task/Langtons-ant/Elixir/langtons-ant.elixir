defmodule Langtons do
  def ant(sizex, sizey) do
    {px, py} = {div(sizex,2), div(sizey,2)}     # start position
    move(MapSet.new, sizex, sizey, px, py, {1,0}, 0)
  end

  defp move(plane, sx, sy, px, py, _, step) when px<0 or sx<px or py<0 or sy<py, do:
    print(plane, sx, sy, px, py, step)
  defp move(plane, sx, sy, px, py, dir, step) do
    {plane2, {dx,dy}} = if {px,py} in plane,
                          do:   {MapSet.delete(plane, {px,py}), turn_right(dir)},
                          else: {MapSet.put(plane, {px,py}), turn_left(dir)}
    move(plane2, sx, sy, px+dx, py+dy, {dx,dy}, step+1)
  end

  defp turn_right({dx, dy}), do: {dy, -dx}
  defp turn_left({dx, dy}), do: {-dy, dx}

  defp print(plane, sx, sy, px, py, step) do
    IO.puts "out of bounds after #{step} moves: (#{px}, #{py})"
    Enum.each(0..sy, fn j ->
      IO.puts Enum.map(0..sx, fn i -> if {i,j} in plane, do: "#", else: "." end)
    end)
  end
end

Langtons.ant(100, 100)
