defmodule Puzzle do
  def sum_and_product do
    s1 = for x <- 2..49, y <- x+1..99, x+y<100, do: {x,y}
    s2 = Enum.filter(s1, fn p ->
      Enum.all?(sumEq(s1,p), fn q -> length(mulEq(s1,q)) != 1 end)
    end)
    s3 = Enum.filter(s2, fn p -> only1?(mulEq(s1,p), s2) end)
    Enum.filter(s3, fn p -> only1?(sumEq(s1,p), s3) end) |> IO.inspect
  end

  defp add({x,y}), do: x + y

  defp mul({x,y}), do: x * y

  defp sumEq(s, p), do: Enum.filter(s, fn q -> add(p) == add(q) end)

  defp mulEq(s, p), do: Enum.filter(s, fn q -> mul(p) == mul(q) end)

  defp only1?(a, b) do
    MapSet.size(MapSet.intersection(MapSet.new(a), MapSet.new(b))) == 1
  end
end

Puzzle.sum_and_product
