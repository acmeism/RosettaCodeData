defmodule SutherlandHodgman do
  defp inside(cp1, cp2, p), do: (cp2.x-cp1.x)*(p.y-cp1.y) > (cp2.y-cp1.y)*(p.x-cp1.x)

  defp intersection(cp1, cp2, s, e) do
    {dcx, dcy} = {cp1.x-cp2.x, cp1.y-cp2.y}
    {dpx, dpy} = {s.x-e.x, s.y-e.y}
    n1 = cp1.x*cp2.y - cp1.y*cp2.x
    n2 = s.x*e.y - s.y*e.x
    n3 = 1.0 / (dcx*dpy - dcy*dpx)
    %{x: (n1*dpx - n2*dcx) * n3, y: (n1*dpy - n2*dcy) * n3}
  end

  def polygon_clipping(subjectPolygon, clipPolygon) do
    Enum.chunk([List.last(clipPolygon) | clipPolygon], 2, 1)
    |> Enum.reduce(subjectPolygon, fn [cp1,cp2],acc ->
         Enum.chunk([List.last(acc) | acc], 2, 1)
         |> Enum.reduce([], fn [s,e],outputList ->
              case {inside(cp1, cp2, e), inside(cp1, cp2, s)} do
                {true,  true} -> [e | outputList]
                {true, false} -> [e, intersection(cp1,cp2,s,e) | outputList]
                {false, true} -> [intersection(cp1,cp2,s,e) | outputList]
                _             -> outputList
              end
            end)
         |> Enum.reverse
       end)
  end
end

subjectPolygon = [[50, 150], [200, 50], [350, 150], [350, 300], [250, 300],
                  [200, 250], [150, 350], [100, 250], [100, 200]]
                 |> Enum.map(fn [x,y] -> %{x: x, y: y} end)

clipPolygon = [[100, 100], [300, 100], [300, 300], [100, 300]]
              |> Enum.map(fn [x,y] -> %{x: x, y: y} end)

SutherlandHodgman.polygon_clipping(subjectPolygon, clipPolygon)
|> Enum.each(&IO.inspect/1)
