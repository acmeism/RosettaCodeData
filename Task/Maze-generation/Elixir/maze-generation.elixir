defmodule Maze do
  def generate(w, h) do
    maze = (for i <- 1..w, j <- 1..h, into: Map.new, do: {{:vis, i, j}, true})
           |> walk(:rand.uniform(w), :rand.uniform(h))
    print(maze, w, h)
    maze
  end

  defp walk(map, x, y) do
    Enum.shuffle( [[x-1,y], [x,y+1], [x+1,y], [x,y-1]] )
    |> Enum.reduce(Map.put(map, {:vis, x, y}, false), fn [i,j],acc ->
      if acc[{:vis, i, j}] do
        {k, v} = if i == x, do: {{:hor, x, max(y, j)}, "+   "},
                          else: {{:ver, max(x, i), y}, "    "}
        walk(Map.put(acc, k, v), i, j)
      else
        acc
      end
    end)
  end

  defp print(map, w, h) do
    Enum.each(1..h, fn j ->
      IO.puts Enum.map_join(1..w, fn i -> Map.get(map, {:hor, i, j}, "+---") end) <> "+"
      IO.puts Enum.map_join(1..w, fn i -> Map.get(map, {:ver, i, j}, "|   ") end) <> "|"
    end)
    IO.puts String.duplicate("+---", w) <> "+"
  end
end

Maze.generate(20, 10)
