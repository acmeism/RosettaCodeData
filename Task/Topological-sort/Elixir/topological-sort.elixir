defmodule Topological do
  def sort(library) do
    g = :digraph.new
    Enum.each(library, fn {l,deps} ->
      :digraph.add_vertex(g,l)           # noop if library already added
      Enum.each(deps, fn d -> add_dependency(g,l,d) end)
    end)
    if t = :digraph_utils.topsort(g) do
      print_path(t)
    else
      IO.puts "Unsortable contains circular dependencies:"
      Enum.each(:digraph.vertices(g), fn v ->
        if vs = :digraph.get_short_cycle(g,v), do: print_path(vs)
      end)
    end
  end

  defp print_path(l), do: IO.puts Enum.join(l, " -> ")

  defp add_dependency(_g,l,l), do: :ok
  defp add_dependency(g,l,d) do
    :digraph.add_vertex(g,d)   # noop if dependency already added
    :digraph.add_edge(g,d,l)   # Dependencies represented as an edge d -> l
  end
end

libraries = [
  des_system_lib:   ~w[std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee]a,
  dw01:             ~w[ieee dw01 dware gtech]a,
  dw02:             ~w[ieee dw02 dware]a,
  dw03:             ~w[std synopsys dware dw03 dw02 dw01 ieee gtech]a,
  dw04:             ~w[dw04 ieee dw01 dware gtech]a,
  dw05:             ~w[dw05 ieee dware]a,
  dw06:             ~w[dw06 ieee dware]a,
  dw07:             ~w[ieee dware]a,
  dware:            ~w[ieee dware]a,
  gtech:            ~w[ieee gtech]a,
  ramlib:           ~w[std ieee]a,
  std_cell_lib:     ~w[ieee std_cell_lib]a,
  synopsys:         []
]
Topological.sort(libraries)

IO.puts ""
bad_libraries = Keyword.update!(libraries, :dw01, &[:dw04 | &1])
Topological.sort(bad_libraries)
