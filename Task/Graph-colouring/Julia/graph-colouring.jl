using Random

"""Useful constants for the colors to be selected for nodes of the graph"""
const colors4 = ["blue", "red", "green", "yellow"]
const badcolor = "black"
@assert(!(badcolor in colors4))

"""
    struct graph

undirected simple graph
constructed from its name and a string listing of point to point connections
"""
mutable struct Graph
    name::String
    g::Dict{Int, Vector{Int}}
    nodecolor::Dict{Int, String}
    function Graph(nam::String, s::String)
        gdic = Dict{Int, Vector{Int}}()
        for p in eachmatch(r"(\d+)-(\d+)|(\d+)(?!\s*-)" , s)
            if p != nothing
                if p[3] != nothing
                    n3 = parse(Int, p[3])
                    get!(gdic, n3, [])
                else
                    n1, n2 = parse(Int, p[1]), parse(Int, p[2])
                    p1vec = get!(gdic, n1, [])
                    !(n2 in p1vec) && push!(p1vec, n2)
                    p2vec = get!(gdic, n2, [])
                    !(n1 in p2vec) && push!(p2vec, n1)
                end
            end
        end
        new(nam, gdic, Dict{Int, String}())
    end
end

"""
    tryNcolors!(gr::Graph, N, maxtrials)

Try up to maxtrials to get a coloring with <= N colors
"""
function tryNcolors!(gr::Graph, N, maxtrials)
    t, mintrial, minord = N, N + 1, Dict()
    for _ in 1:maxtrials
        empty!(gr.nodecolor)
        ordering = shuffle(collect(keys(gr.g)))
        for node in ordering
            usedneighborcolors = [gr.nodecolor[c] for c in gr.g[node] if haskey(gr.nodecolor, c)]
            gr.nodecolor[node] = badcolor
            for c in colors4[1:N]
                if !(c in usedneighborcolors)
                    gr.nodecolor[node] = c
                    break
                end
            end
        end
        t = length(unique(values(gr.nodecolor)))
        if t < mintrial
            mintrial = t
            minord = deepcopy(gr.nodecolor)
        end
    end
    if length(minord) > 0
        gr.nodecolor = minord
    end
end


"""
    prettyprintcolors(gr::graph)

print out the colored nodes in graph
"""
function prettyprintcolors(gr::Graph)
    println("\nColors for the graph named ", gr.name, ":")
    edgesdone = Vector{Vector{Int}}()
    for (node, neighbors) in gr.g
        if !isempty(neighbors)
            for n in neighbors
                edge = node < n ? [node, n] : [n, node]
                if !(edge in edgesdone)
                    println("    ", edge[1], "-", edge[2], " Color: ",
                        gr.nodecolor[edge[1]], ", ", gr.nodecolor[edge[2]])
                    push!(edgesdone, edge)
                end
            end
        else
            println("    ", node, ": ", gr.nodecolor[node])
        end
    end
    println("\n", length(unique(keys(gr.nodecolor))), " nodes, ",
        length(edgesdone), " edges, ",
        length(unique(values(gr.nodecolor))), " colors.")
end

for (name, txt) in [("Ex1", "0-1 1-2 2-0 3"),
    ("Ex2", "1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7"),
    ("Ex3", "1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6"),
    ("Ex4", "1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7")]
    exgraph = Graph(name, txt)
    tryNcolors!(exgraph, 4, 100)
    prettyprintcolors(exgraph)
end
