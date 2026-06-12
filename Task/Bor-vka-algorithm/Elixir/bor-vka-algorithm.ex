defmodule Edge do
  defstruct [:u, :v, :weight]

  def new(u, v, weight) do
    %Edge{u: u, v: v, weight: weight}
  end
end

defmodule Graph do
  defstruct [:vertex_count, :edges]

  def new(vertex_count) do
    %Graph{vertex_count: vertex_count, edges: []}
  end

  def add_edge(graph, edge) do
    %{graph | edges: [edge | graph.edges]}
  end

  def boruvka_minimum_spanning_tree(graph) do
    # Initialize parent array where each vertex is its own parent
    parent = Enum.into(0..(graph.vertex_count - 1), %{}, fn i -> {i, i} end)
    # Initialize rank array where each vertex has rank 0
    rank = Enum.into(0..(graph.vertex_count - 1), %{}, fn i -> {i, 0} end)

    # Store the indexes of the cheapest edge of each tree
    cheapest = Enum.into(0..(graph.vertex_count - 1), %{}, fn i ->
      {i, %Edge{u: -1, v: -1, weight: -1.0}}
    end)

    # Initially there are 'vertex_count' different trees
    tree_count = graph.vertex_count
    minimum_spanning_tree_weight = 0

    boruvka_algorithm(graph, parent, rank, cheapest, tree_count, minimum_spanning_tree_weight)
  end

  defp boruvka_algorithm(graph, parent, rank, cheapest, tree_count, minimum_spanning_tree_weight) when tree_count > 1 do
    # Traverse through all edges and update cheapest edge for every tree
    new_cheapest = update_cheapest_edges(graph.edges, parent, cheapest)

    # Add the cheapest edges to the minimum spanning tree
    {new_parent, new_rank, new_tree_count, new_minimum_spanning_tree_weight} =
      add_cheapest_edges(new_cheapest, graph.vertex_count, parent, rank, tree_count, minimum_spanning_tree_weight)

    # Reset cheapest edges for next iteration
    reset_cheapest = Enum.into(0..(graph.vertex_count - 1), %{}, fn i ->
      {i, %Edge{u: -1, v: -1, weight: -1.0}}
    end)

    boruvka_algorithm(graph, new_parent, new_rank, reset_cheapest, new_tree_count, new_minimum_spanning_tree_weight)
  end

  defp boruvka_algorithm(_graph, _parent, _rank, _cheapest, _tree_count, minimum_spanning_tree_weight) do
    IO.puts("\nWeight of minimum spanning tree is #{minimum_spanning_tree_weight}")
  end

  defp update_cheapest_edges(edges, parent, cheapest) do
    Enum.reduce(edges, cheapest, fn edge, acc ->
      u = edge.u
      v = edge.v
      weight = edge.weight

      index1 = find(parent, u)
      index2 = find(parent, v)

      # If vertices belong to different trees, update cheapest if needed
      if index1 != index2 do
        acc1 = if Map.get(acc, index1).weight == -1.0 || Map.get(acc, index1).weight > weight do
          Map.put(acc, index1, %Edge{u: u, v: v, weight: weight})
        else
          acc
        end

        if Map.get(acc1, index2).weight == -1.0 || Map.get(acc1, index2).weight > weight do
          Map.put(acc1, index2, %Edge{u: u, v: v, weight: weight})
        else
          acc1
        end
      else
        acc
      end
    end)
  end

  defp add_cheapest_edges(cheapest, vertex_count, parent, rank, tree_count, minimum_spanning_tree_weight) do
    Enum.reduce(0..(vertex_count - 1), {parent, rank, tree_count, minimum_spanning_tree_weight},
      fn vertex, {curr_parent, curr_rank, curr_tree_count, curr_weight} ->
        # Check if there's a valid cheapest edge for this vertex
        edge = Map.get(cheapest, vertex)

        if edge.weight != -1.0 do
          u = edge.u
          v = edge.v
          weight = edge.weight

          index1 = find(curr_parent, u)
          index2 = find(curr_parent, v)

          if index1 != index2 do
            new_weight = curr_weight + weight
            {new_parent, new_rank} = union_set(curr_parent, curr_rank, index1, index2)

            IO.puts("Edge #{u}--#{v} with weight #{weight} is included in the minimum spanning tree")

            {new_parent, new_rank, curr_tree_count - 1, new_weight}
          else
            {curr_parent, curr_rank, curr_tree_count, curr_weight}
          end
        else
          {curr_parent, curr_rank, curr_tree_count, curr_weight}
        end
      end)
  end

  # Return the index of the tree containing 'vertex', using path compression
  defp find(parent, vertex) do
    parent_vertex = Map.get(parent, vertex)

    if parent_vertex != vertex do
      root = find(parent, parent_vertex)
      # Path compression
      new_parent = Map.put(parent, vertex, root)
      find(new_parent, vertex)
    else
      parent_vertex
    end
  end

  # Union by rank of two trees
  defp union_set(parent, rank, u, v) do
    u_root = find(parent, u)
    v_root = find(parent, v)

    cond do
      Map.get(rank, u_root) < Map.get(rank, v_root) ->
        {Map.put(parent, u_root, v_root), rank}

      Map.get(rank, u_root) > Map.get(rank, v_root) ->
        {Map.put(parent, v_root, u_root), rank}

      true -> # Ranks are equal
        new_parent = Map.put(parent, v_root, u_root)
        new_rank = Map.put(rank, u_root, Map.get(rank, u_root) + 1)
        {new_parent, new_rank}
    end
  end
end

defmodule BoruvkaAlgorithm do
  def main do
    graph = Graph.new(4)
    |> Graph.add_edge(Edge.new(0, 1, 10.0))
    |> Graph.add_edge(Edge.new(0, 2, 6.0))
    |> Graph.add_edge(Edge.new(0, 3, 5.0))
    |> Graph.add_edge(Edge.new(1, 3, 15.0))
    |> Graph.add_edge(Edge.new(2, 3, 4.0))

    Graph.boruvka_minimum_spanning_tree(graph)
  end
end

BoruvkaAlgorithm.main()
