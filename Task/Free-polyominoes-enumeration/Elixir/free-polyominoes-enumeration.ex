defmodule Polyominoes do
  defp translate2origin(poly) do
    # Finds the min x and y coordiate of a Polyomino.
    minx = Enum.map(poly, &elem(&1,0)) |> Enum.min
    miny = Enum.map(poly, &elem(&1,1)) |> Enum.min
    Enum.map(poly, fn {x,y} -> {x - minx, y - miny} end) |> Enum.sort
  end

  defp rotate90({x, y}), do: {y, -x}
  defp reflect({x, y}), do: {-x, y}

  # All the plane symmetries of a rectangular region.
  defp rotations_and_reflections(poly) do
    poly1 = Enum.map(poly,  &rotate90/1)
    poly2 = Enum.map(poly1, &rotate90/1)
    poly3 = Enum.map(poly2, &rotate90/1)
    poly4 = Enum.map(poly3, &reflect/1)
    poly5 = Enum.map(poly4, &rotate90/1)
    poly6 = Enum.map(poly5, &rotate90/1)
    poly7 = Enum.map(poly6, &rotate90/1)
    [poly, poly1, poly2, poly3, poly4, poly5, poly6, poly7]
  end

  defp canonical(poly) do
    rotations_and_reflections(poly) |> Enum.map(&translate2origin/1)
  end

  # All four points in Von Neumann neighborhood.
  defp contiguous({x,y}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
  end

  # Finds all distinct points that can be added to a Polyomino.
  defp new_points(poly) do
    points = Enum.flat_map(poly, &contiguous/1)
    Enum.uniq(points) -- poly
  end

  defp new_polys(polys) do
    Enum.reduce(polys, {[], HashSet.new}, fn poly, {polyomino, pattern} ->
      Enum.reduce(new_points(poly), {polyomino, pattern}, fn point, {pol, pat} ->
        pl = translate2origin([point | poly])
        if pl in pat do
          {pol, pat}
        else
          canon = canonical(pl)
          {[Enum.min(canon) | pol], Enum.into(canon, pat)}
        end
      end)
    end)
    |> elem(0)
  end

  # Generates polyominoes of rank n recursively.
  def rank(0), do: [[]]
  def rank(1), do: [[{0,0}]]
  def rank(n), do: new_polys(rank(n-1))

  # Generates a textual representation of a Polyomino.
  def text_representation(poly) do
    table = Enum.map(poly, &{&1, "#"}) |> Enum.into(Map.new)
    maxx = Enum.map(poly, &elem(&1,0)) |> Enum.max
    maxy = Enum.map(poly, &elem(&1,1)) |> Enum.max
    Enum.map_join(0..maxx, "\n", fn x ->
      Enum.map_join(0..maxy, fn y -> Dict.get(table, {x,y}, " ") end)
    end)
  end
end

IO.inspect Enum.map(0..10, fn n -> length(Polyominoes.rank(n)) end)

n = if System.argv==[], do: 5, else: String.to_integer(hd(System.argv))
IO.puts "\nAll free polyominoes of rank #{n}:"
Enum.sort(Polyominoes.rank(n))
|> Enum.each(fn poly -> IO.puts "#{Polyominoes.text_representation(poly)}\n" end)
