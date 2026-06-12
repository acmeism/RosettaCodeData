defmodule Ramsey do
  def main(n\\17) do
    vertices = Enum.to_list(0 .. n-1)
    g = create_graph(n,vertices)
    edges = for v1 <- :digraph.vertices(g), v2 <- :digraph.out_neighbours(g, v1), do: {v1,v2}
    print_graph(vertices,edges)
    case ramsey_check(vertices,edges) do
      true           -> "Satisfies Ramsey condition."
      {false,reason} -> "Not satisfies Ramsey condition:\n#{inspect reason}"
    end
    |> IO.puts
  end

  def create_graph(n,vertices) do
    g = :digraph.new([:cyclic])
    for v <- vertices, do: :digraph.add_vertex(g,v)
    for i <- vertices, k <- [1,2,4,8] do
      j = rem(i + k, n)
      :digraph.add_edge(g, i, j)
      :digraph.add_edge(g, j, i)
    end
    g
  end

  def print_graph(vertices,edges) do
    Enum.each(vertices, fn j ->
      Enum.map_join(vertices, " ", fn i ->
        cond do
          i==j           -> "-"
          {i,j} in edges -> "1"
          true           -> "0"
        end
      end)
      |> IO.puts
    end)
  end

  def ramsey_check(vertices,edges) do
    listconditions =
      for v1 <- vertices, v2 <- vertices, v3 <- vertices, v4 <- vertices,
          v1 != v2, v1 != v3, v1 != v4, v2 != v3, v2 != v4, v3 != v4
          do
            all_cases = [ {v1,v2} in edges, {v1,v3} in edges, {v1,v4} in edges,
                          {v2,v3} in edges, {v2,v4} in edges, {v3,v4} in edges ]
            {v1, v2, v3, v4, Enum.any?(all_cases), not(Enum.all?(all_cases))}
          end
    if Enum.all?(listconditions, fn {_,_,_,_,c1,c2} -> c1 and c2 end) do
      true
    else
      {false, (for {v1,v2,v3,v4,false,_} <- listconditions, do: {:wholly_unconnected,v1,v2,v3,v4})
           ++ (for {v1,v2,v3,v4,_,false} <- listconditions, do: {:wholly_connected,v1,v2,v3,v4}) }
    end
  end
end

Ramsey.main
