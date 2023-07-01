defmodule Fibonacci do
  def fibonacci_word, do: Stream.unfold({"1","0"}, fn{a,b} -> {a, {b, b<>a}} end)

  def word_fractal(n) do
    word = fibonacci_word |> Enum.at(n)
    walk(to_char_list(word), 1, 0, 0, 0, -1, %{{0,0}=>"S"})
    |> print
  end

  defp walk([], _, _, _, _, _, map), do: map
  defp walk([h|t], n, x, y, dx, dy, map) do
    map2 = Map.put(map, {x+dx, y+dy}, (if dx==0, do: "|", else: "-"))
           |> Map.put({x2=x+2*dx, y2=y+2*dy}, "+")
    if h == ?0 do
      if rem(n,2)==0, do: walk(t, n+1, x2, y2, dy, -dx, map2),
                    else: walk(t, n+1, x2, y2, -dy, dx, map2)
    else
      walk(t, n+1, x2, y2, dx, dy, map2)
    end
  end

  defp print(map) do
    xkeys = Map.keys(map) |> Enum.map(fn {x,_} -> x end)
    {xmin, xmax} = Enum.min_max(xkeys)
    ykeys = Map.keys(map) |> Enum.map(fn {_,y} -> y end)
    {ymin, ymax} = Enum.min_max(ykeys)
    Enum.each(ymin..ymax, fn y ->
      IO.puts Enum.map(xmin..xmax, fn x -> Map.get(map, {x,y}, " ") end)
    end)
  end
end

Fibonacci.word_fractal(16)
