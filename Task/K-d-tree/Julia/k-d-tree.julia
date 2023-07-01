ENV["NN_DEBUG"] = true # or change DEBUG = true in NearestNeighbors.jl file

using NearestNeighbors

const data = [[2, 3] [5, 4] [9, 6] [4, 7] [8, 1] [7, 2]]

NearestNeighbors.reset_stats()
const kdtree = KDTree(Float64.(data))
const indexpoint = [9,2]
idx, dist = knn(kdtree, indexpoint, 1)
println("Wikipedia example: The nearest neighbor to $indexpoint is ",
    "$(data[1:2, idx[1]]) at distance $(dist).")
NearestNeighbors.print_stats()

NearestNeighbors.reset_stats()
const cubedis = rand(3, 1000)
const kdcubetree = KDTree(cubedis)
const rand3point = rand(3, 1)
idx, dist = knn(kdcubetree, rand3point, 1)
println("\n\n1000 cube points: The point $rand3point is closest to the point $(cubedis[1:3, idx[1]])",
    " at distance $(dist[1]).")
NearestNeighbors.print_stats()

NearestNeighbors.reset_stats()
const cubedis2 = rand(3, 500000)
const kdcubetree2 = KDTree(cubedis2)
const rand3point2 = rand(3, 1)
idx, dist = knn(kdcubetree2, rand3point2, 1)
println("\n\nExtra: The point $rand3point2 is closest to the point $(cubedis2[1:3, idx[1]]) out of $(size(cubedis2)[2]) points,",
    " at distance $(dist[1]).")
NearestNeighbors.print_stats()
