using LightGraphs

const grid = reshape(Vector{UInt8}(replace("""
         00000
      00003130000
    000321322221000
   00231222432132200
  0041433223233211100
  0232231612142618530
 003152122326114121200
 031252235216111132210
 022211246332311115210
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
 013322444412122123210
 015132331312411123120
 003333612214233913300
  0219126511415312570
  0021321524341325100
   00211415413523200
    000122111322000
      00001120000
         00000         """, "\n" => "")), 23, 23)

const board = map(c -> c == UInt8(' ') ? -1 : c - UInt8('0'), grid)
const startingpoints = [i for i in 1:529 if board[i] > 0]
const safety = [i for i in 1:529 if board[i] == 0]
const legalendpoints = [i for i in 1:529 if board[i] >= 0]

function adjacent(i)
    k, ret = board[i], Int[]
    row, col = divrem(i - 1, 23) .+ 1
    col > k && push!(ret, i - k)
    23 - col >= k && push!(ret, i + k)
    row > k && push!(ret, i - 23 * k)
    row + k <= 23 && push!(ret, i + 23 * k)
    row > k && col > k && push!(ret, i - 24 * k)
    row + k <= 23 && (23 - col >= k) && push!(ret, i + 24 * k)
    row > k && (23 - col >= k) && push!(ret, i - 22 * k)
    row + k <= 23 && col > k && push!(ret, i + 22 * k)
    ret
end

const graph = SimpleDiGraph(529)

for i in 1:529
    if board[i] > 0
        for p in adjacent(i)
            if board[p] >= 0
                add_edge!(graph, i, p)
            end
        end
    end
end

"""
    allnpaths(graph, a, b, vec, n)

Return a vector of int vectors, each of which is a path from a to a member of
vec and where n is the length of each path and the nodes in a path do not repeat.
"""
function allnpaths(graph, a, vec, n)
    ret = [[a]]
    for j in 2:n
        nextret = Vector{Vector{Int}}()
        for path in ret, x in neighbors(graph, path[end])
            if !(x in path) && (j < n || x in vec)
                push!(nextret, [path; x])
            end
        end
        ret = nextret
    end
    return (ret == [[a]] && a != b) ? [] : ret
end

function pathtostring(path)
    ret = ""
    for node in path
        c = CartesianIndices(board)[node]
        ret *= "($(c[2]-1), $(c[1]-1)) "
    end
    ret
end

function pathlisting(paths)
    join([pathtostring(p) for p in paths], "\n")
end

println("Part 1:")
let
    start = 23 * 11 + 12
    pathsfromcenter = dijkstra_shortest_paths(graph, start)
    safepaths = filter(p -> length(p) > 1, enumerate_paths(pathsfromcenter, safety))
    safelen = mapreduce(length, min, safepaths)
    paths = unique(allnpaths(graph, start, safety, safelen))
    println("The $(length(paths)) shortest paths to safety are:\n",
        pathlisting(paths))
end

println("\nPart 2:")
let
    p = enumerate_paths(bellman_ford_shortest_paths(graph, 21 * 23 + 12), 23 + 12)
    println("One shortest route from (21, 11) to (1, 11): ", pathtostring(p))

    p = enumerate_paths(bellman_ford_shortest_paths(graph, 23 + 12), 21 * 23 + 12)
    println("\nOne shortest route from (1, 11) to (21, 11): ", pathtostring(p))

    allshortpaths = [enumerate_paths(bellman_ford_shortest_paths(graph, 23 + 12), p) for p in startingpoints]
    maxlen, idx = findmax(map(length, allshortpaths))
    println("\nLongest Shortest Route (length $(maxlen - 1)) is: ", pathtostring(allshortpaths[idx]))
end

println("\nExtra Credit Questions:")
let
    println("\nIs there any cell in the country that can not be reached from HQ (11, 11)?")
    frombase = bellman_ford_shortest_paths(graph, 11 * 23 + 12)
    unreached = Int[]
    for pt in legalendpoints
        path = enumerate_paths(frombase, pt)
        if isempty(path) && pt != 11 * 23 + 12
            push!(unreached, pt)
        end
    end
    print("There are $(length(unreached)): ")
    println(pathtostring(unreached))

    println("\nWhich cells will it take longest to send reinforcements to from HQ (11, 11)?")
    p = [enumerate_paths(frombase, x) for x in legalendpoints]
    maxlen = mapreduce(length, max, p)
    allmax = [path for path in p if length(path) == maxlen]
    println("There are $(length(allmax)) of length $(maxlen - 1):")
    println(pathlisting(allmax))
end
