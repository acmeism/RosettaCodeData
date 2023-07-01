using LightGraphs

edge_list=[(1,2),(3,1),(6,3),(6,7),(7,6),(2,3),(4,2),(4,3),(4,5),(5,6),(5,4),(8,5),(8,8),(8,7)]

grph = SimpleDiGraph(Edge.(edge_list))

tarj = strongly_connected_components(grph)

inzerobase(arrarr) = map(x -> sort(x .- 1, rev=true), arrarr)

println("Results in the zero-base scheme: $(inzerobase(tarj))")
