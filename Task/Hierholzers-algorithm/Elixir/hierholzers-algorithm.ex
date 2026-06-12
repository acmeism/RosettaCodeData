defmodule HierholzersAlgorithm do
  def main(_) do
    # First adjacency list example
    adjacency_list1 = [
      [1], # Vertex 0 connects to vertex 1
      [2], # Vertex 1 connects to vertex 2
      [0]  # Vertex 2 connects to vertex 0
    ]
    IO.puts("Circuit for Adjacency List 1:")
    print_circuit(adjacency_list1)

    # Second adjacency list example
    adjacency_list2 = [
      [1, 6], # Vertex 0 connects to vertices 1, 6
      [2],    # Vertex 1 connects to vertex 2
      [0, 3], # Vertex 2 connects to vertices 0, 3
      [4],    # Vertex 3 connects to vertex 4
      [2, 5], # Vertex 4 connects to vertices 2, 5
      [0],    # Vertex 5 connects to vertex 0
      [4]     # Vertex 6 connects to vertex 4
    ]
    IO.puts("\nCircuit for Adjacency List 2:")
    print_circuit(adjacency_list2)
  end

  def print_circuit([]), do: :ok
  def print_circuit(adjacency_list) do
    path = [0] # Start with vertex 0 on the path stack
    circuit = []
    adj_map = create_adjacency_map(adjacency_list, 0, %{})

    final_circuit = find_circuit(0, path, circuit, adj_map)
    print_result(:lists.reverse(final_circuit))
  end

  defp create_adjacency_map([], _, map), do: map
  defp create_adjacency_map([neighbors | rest], index, map) do
    create_adjacency_map(rest, index + 1, Map.put(map, index, neighbors))
  end

  defp find_circuit(_current_vertex, [], circuit, _), do: circuit
  defp find_circuit(current_vertex, path, circuit, adj_map) do
    case Map.fetch(adj_map, current_vertex) do
      {:ok, []} ->
        # No more neighbors - backtrack
        new_circuit = [current_vertex | circuit]
        [new_current_vertex | rest_path] = path
        find_circuit(new_current_vertex, rest_path, new_circuit, adj_map)

      {:ok, neighbors} ->
        # Has neighbors - move forward
        next_vertex = List.last(neighbors)
        remaining_neighbors = List.delete_at(neighbors, -1)
        new_adj_map = Map.put(adj_map, current_vertex, remaining_neighbors)
        new_path = [current_vertex | path]
        find_circuit(next_vertex, new_path, circuit, new_adj_map)

      :error ->
        # Vertex not found - backtrack
        new_circuit = [current_vertex | circuit]
        [new_current_vertex | rest_path] = path
        find_circuit(new_current_vertex, rest_path, new_circuit, adj_map)
    end
  end

  defp print_result([]), do: IO.puts("")
  defp print_result([vertex]), do: IO.puts("#{vertex}")
  defp print_result([vertex | rest]) do
    IO.write("#{vertex} => ")
    print_result(rest)
  end
end

# Call the main function to execute the program
HierholzersAlgorithm.main(:ok)

