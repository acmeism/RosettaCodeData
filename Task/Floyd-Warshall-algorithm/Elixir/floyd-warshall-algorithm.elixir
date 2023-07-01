defmodule Floyd_Warshall do
  def main(n, edge) do
    {dist, next} = setup(n, edge)
    {dist, next} = shortest_path(n, dist, next)
    print(n, dist, next)
  end

  defp setup(n, edge) do
    big = 1.0e300
    dist = for i <- 1..n, j <- 1..n, into: %{}, do: {{i,j},(if i==j, do: 0, else: big)}
    next = for i <- 1..n, j <- 1..n, into: %{}, do: {{i,j}, nil}
    Enum.reduce(edge, {dist,next}, fn {u,v,w},{dst,nxt} ->
      { Map.put(dst, {u,v}, w), Map.put(nxt, {u,v}, v) }
    end)
  end

  defp shortest_path(n, dist, next) do
    (for k <- 1..n, i <- 1..n, j <- 1..n, do: {k,i,j})
    |> Enum.reduce({dist,next}, fn {k,i,j},{dst,nxt} ->
         if dst[{i,j}] > dst[{i,k}] + dst[{k,j}] do
           {Map.put(dst, {i,j}, dst[{i,k}] + dst[{k,j}]), Map.put(nxt, {i,j}, nxt[{i,k}])}
         else
           {dst, nxt}
         end
       end)
  end

  defp print(n, dist, next) do
    IO.puts "pair     dist    path"
    for i <- 1..n, j <- 1..n, i != j,
        do: :io.format "~w -> ~w  ~4w     ~s~n", [i, j, dist[{i,j}], path(next, i, j)]
  end

  defp path(next, i, j), do: path(next, i, j, [i]) |> Enum.join(" -> ")

  defp path(_next, i, i, list), do: Enum.reverse(list)
  defp path(next, i, j, list) do
    u = next[{i,j}]
    path(next, u, j, [u | list])
  end
end

edge = [{1, 3, -2}, {2, 1, 4}, {2, 3, 3}, {3, 4, 2}, {4, 2, -1}]
Floyd_Warshall.main(4, edge)
