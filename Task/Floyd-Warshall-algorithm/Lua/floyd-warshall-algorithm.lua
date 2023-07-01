function printResult(dist, nxt)
    print("pair     dist    path")
    for i=0, #nxt do
        for j=0, #nxt do
            if i ~= j then
                u = i + 1
                v = j + 1
                path = string.format("%d -> %d    %2d     %s", u, v, dist[i][j], u)
                repeat
                    u = nxt[u-1][v-1]
                    path = path .. " -> " .. u
                until (u == v)
                print(path)
            end
        end
    end
end

function floydWarshall(weights, numVertices)
    dist = {}
    for i=0, numVertices-1 do
        dist[i] = {}
        for j=0, numVertices-1 do
            dist[i][j] = math.huge
        end
    end

    for _,w in pairs(weights) do
        -- the weights array is one based
        dist[w[1]-1][w[2]-1] = w[3]
    end

    nxt = {}
    for i=0, numVertices-1 do
        nxt[i] = {}
        for j=0, numVertices-1 do
            if i ~= j then
                nxt[i][j] = j+1
            end
        end
    end

    for k=0, numVertices-1 do
        for i=0, numVertices-1 do
            for j=0, numVertices-1 do
                if dist[i][k] + dist[k][j] < dist[i][j] then
                    dist[i][j] = dist[i][k] + dist[k][j]
                    nxt[i][j] = nxt[i][k]
                end
            end
        end
    end

    printResult(dist, nxt)
end

weights = {
    {1, 3, -2},
    {2, 1, 4},
    {2, 3, 3},
    {3, 4, 2},
    {4, 2, -1}
}
numVertices = 4
floydWarshall(weights, numVertices)
