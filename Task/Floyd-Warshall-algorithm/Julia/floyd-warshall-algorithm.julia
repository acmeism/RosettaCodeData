# Floyd-Warshall algorithm: https://rosettacode.org/wiki/Floyd-Warshall_algorithm
# v0.6

function floydwarshall(weights::Matrix, nvert::Int)
    dist = fill(Inf, nvert, nvert)
    for i in 1:size(weights, 1)
        dist[weights[i, 1], weights[i, 2]] = weights[i, 3]
    end
    # return dist
    next = collect(j != i ? j : 0 for i in 1:nvert, j in 1:nvert)

    for k in 1:nvert, i in 1:nvert, j in 1:nvert
        if dist[i, k] + dist[k, j] < dist[i, j]
            dist[i, j] = dist[i, k] + dist[k, j]
            next[i, j] = next[i, k]
        end
    end

    # return next
    function printresult(dist, next)
        println("pair     dist    path")
        for i in 1:size(next, 1), j in 1:size(next, 2)
            if i != j
                u = i
                path = @sprintf "%d -> %d    %2d     %s" i j dist[i, j] i
                while true
                    u = next[u, j]
                    path *= " -> $u"
                    if u == j break end
                end
                println(path)
            end
        end
    end
    printresult(dist, next)
end

floydwarshall([1 3 -2; 2 1 4; 2 3 3; 3 4 2; 4 2 -1], 4)
