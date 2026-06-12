-- Helper Classes
local Point = {}
Point.__index = Point

function Point.new(x, y, id)
    local self = setmetatable({}, Point)
    self.x = x
    self.y = y
    self.id = id
    return self
end

local Edge = {}
Edge.__index = Edge

function Edge.new(u, v, weight)
    local self = setmetatable({}, Edge)
    self.u = u
    self.v = v
    self.weight = weight
    return self
end

local UnionFind = {}
UnionFind.__index = UnionFind

function UnionFind.new(n)
    local self = setmetatable({}, UnionFind)
    self.parent = {}
    self.rank = {}
    for i = 1, n do
        self.parent[i] = i
        self.rank[i] = 0
    end
    return self
end

function UnionFind:find(i)
    if self.parent[i] ~= i then
        self.parent[i] = self:find(self.parent[i]) -- Path compression
    end
    return self.parent[i]
end

function UnionFind:unite(i, j)
    local root_i = self:find(i)
    local root_j = self:find(j)

    if root_i ~= root_j then
        -- Union by rank
        if self.rank[root_i] < self.rank[root_j] then
            self.parent[root_i] = root_j
        elseif self.rank[root_i] > self.rank[root_j] then
            self.parent[root_j] = root_i
        else
            self.parent[root_j] = root_i
            self.rank[root_i] = self.rank[root_i] + 1
        end
    end
end

-- Helper Functions
local function print_container(container, name)
    io.write(name .. ": [")
    for i, v in ipairs(container) do
        if i > 1 then io.write(", ") end
        io.write(v)
    end
    io.write("]\n")
end

local function print_edges(edges, name)
    io.write(name .. ": [")
    for i, edge in ipairs(edges) do
        if i > 1 then io.write(", ") end
        io.write(string.format("(%d, %d, %.2f)", edge.u, edge.v, edge.weight))
    end
    io.write("]\n")
end

local function print_graph(graph, name)
    io.write(name .. ": {\n")
    for i = 1, #graph do
        io.write("  " .. i .. ": {")
        for j = 1, #graph[i] do
            if i ~= j then
                io.write(string.format("%d: %.2f", j, graph[i][j]))
                if j < #graph[i] then io.write(", ") end
            end
        end
        io.write("}" .. (i == #graph and "" or ",") .. "\n")
    end
    io.write("}\n")
end

-- Euclidean Distance
local function get_length(p1, p2)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    return math.sqrt(dx * dx + dy * dy)
end

-- Build Complete Graph (Adjacency Matrix)
local function build_graph(data)
    local n = #data
    local graph = {}

    for i = 1, n do
        graph[i] = {}
        for j = 1, n do
            graph[i][j] = 0.0
        end
    end

    for i = 1, n do
        for j = i + 1, n do
            local dist = get_length(data[i], data[j])
            graph[i][j] = dist
            graph[j][i] = dist -- Symmetric graph
        end
    end

    return graph
end

-- Minimum Spanning Tree (Kruskal's Algorithm)
local function minimum_spanning_tree(graph)
    local n = #graph
    if n == 0 then return {} end

    local edges = {}
    for i = 1, n do
        for j = i + 1, n do
            table.insert(edges, Edge.new(i, j, graph[i][j]))
        end
    end

    -- Sort edges by weight
    table.sort(edges, function(a, b) return a.weight < b.weight end)

    local mst = {}
    local uf = UnionFind.new(n)
    local edges_count = 0

    for _, edge in ipairs(edges) do
        if uf:find(edge.u) ~= uf:find(edge.v) then
            table.insert(mst, edge)
            uf:unite(edge.u, edge.v)
            edges_count = edges_count + 1
            if edges_count == n - 1 then break end -- MST has n-1 edges
        end
    end

    return mst
end

-- Find Vertices with Odd Degree in MST
local function find_odd_vertexes(mst, n)
    local degree = {}
    for i = 1, n do degree[i] = 0 end

    for _, edge in ipairs(mst) do
        degree[edge.u] = degree[edge.u] + 1
        degree[edge.v] = degree[edge.v] + 1
    end

    local odd_vertices = {}
    for i = 1, n do
        if degree[i] % 2 ~= 0 then
            table.insert(odd_vertices, i)
        end
    end

    return odd_vertices
end

-- Minimum Weight Matching (Greedy Heuristic)
local function minimum_weight_matching(mst, graph, odd_vertices)
    local current_odd = {}
    for _, v in ipairs(odd_vertices) do table.insert(current_odd, v) end

    -- Shuffle the current_odd table
    for i = #current_odd, 2, -1 do
        local j = math.random(i)
        current_odd[i], current_odd[j] = current_odd[j], current_odd[i]
    end

    local matched = {}
    for i = 1, #graph do matched[i] = false end

    for i = 1, #current_odd do
        local v = current_odd[i]
        if matched[v] then goto continue end

        local min_length = math.huge
        local closest_u = -1

        for j = i + 1, #current_odd do
            local u = current_odd[j]
            if not matched[u] then
                if graph[v][u] < min_length then
                    min_length = graph[v][u]
                    closest_u = u
                end
            end
        end

        if closest_u ~= -1 then
            table.insert(mst, Edge.new(v, closest_u, min_length))
            matched[v] = true
            matched[closest_u] = true
        end

        ::continue::
    end
end

-- Find Eulerian Tour (Hierholzer's Algorithm)
local function find_eulerian_tour(matched_mst, n)
    if #matched_mst == 0 then return {} end

    local adj = {}
    for i = 1, n do adj[i] = {} end

    local edge_used = {}
    for _, edge in ipairs(matched_mst) do
        table.insert(adj[edge.u], {edge.v, edge})
        table.insert(adj[edge.v], {edge.u, edge})
        edge_used[edge] = false
    end

    local tour = {}
    local current_path = {}

    local start_node = matched_mst[1].u
    table.insert(current_path, start_node)

    while #current_path > 0 do
        local current_node = current_path[#current_path]
        local found_edge = false

        for _, neighbor_info in ipairs(adj[current_node]) do
            local neighbor, edge_ptr = neighbor_info[1], neighbor_info[2]

            if not edge_used[edge_ptr] then
                edge_used[edge_ptr] = true
                table.insert(current_path, neighbor)
                found_edge = true
                break
            end
        end

        if not found_edge then
            table.insert(tour, table.remove(current_path))
        end
    end

    -- Reverse the tour to get the correct order
    local reversed_tour = {}
    for i = #tour, 1, -1 do
        table.insert(reversed_tour, tour[i])
    end

    return reversed_tour
end

-- Main TSP Function (Christofides Approximation)
local function tsp(data)
    local n = #data

    if n == 0 then return 0.0, {} end
    if n == 1 then return 0.0, {data[1].id} end

    local G = build_graph(data)
    -- print_graph(G, "Graph")

    local MSTree = minimum_spanning_tree(G)
    print_edges(MSTree, "MSTree")

    local odd_vertexes = find_odd_vertexes(MSTree, n)
    print_container(odd_vertexes, "Odd vertexes in MSTree")

    minimum_weight_matching(MSTree, G, odd_vertexes)
    print_edges(MSTree, "Minimum weight matching (MST + Matching Edges)")

    local eulerian_tour = find_eulerian_tour(MSTree, n)
    print_container(eulerian_tour, "Eulerian tour")

    if #eulerian_tour == 0 then
        print("Error: Eulerian tour could not be found.")
        return -1.0, {}
    end

    local path = {}
    local length = 0.0
    local visited = {}
    for i = 1, n do visited[i] = false end

    local current = eulerian_tour[1]
    table.insert(path, current)
    visited[current] = true

    for i = 2, #eulerian_tour do
        local v = eulerian_tour[i]
        if not visited[v] then
            table.insert(path, v)
            visited[v] = true
            length = length + G[current][v]
            current = v
        end
    end

    length = length + G[current][path[1]]
    table.insert(path, path[1])

    print_container(path, "Result path")
    print(string.format("Result length of the path: %.2f", length))

    return length, path
end

-- Main Program
local raw_data = {
    {1380, 939}, {2848, 96}, {3510, 1671}, {457, 334}, {3888, 666}, {984, 965}, {2721, 1482}, {1286, 525},
    {2716, 1432}, {738, 1325}, {1251, 1832}, {2728, 1698}, {3815, 169}, {3683, 1533}, {1247, 1945}, {123, 862},
    {1234, 1946}, {252, 1240}, {611, 673}, {2576, 1676}, {928, 1700}, {53, 857}, {1807, 1711}, {274, 1420},
    {2574, 946}, {178, 24}, {2678, 1825}, {1795, 962}, {3384, 1498}, {3520, 1079}, {1256, 61}, {1424, 1728},
    {3913, 192}, {3085, 1528}, {2573, 1969}, {463, 1670}, {3875, 598}, {298, 1513}, {3479, 821}, {2542, 236},
    {3955, 1743}, {1323, 280}, {3447, 1830}, {2936, 337}, {1621, 1830}, {3373, 1646}, {1393, 1368},
    {3874, 1318}, {938, 955}, {3022, 474}, {2482, 1183}, {3854, 923}, {376, 825}, {2519, 135}, {2945, 1622},
    {953, 268}, {2628, 1479}, {2097, 981}, {890, 1846}, {2139, 1806}, {2421, 1007}, {2290, 1810}, {1115, 1052},
    {2588, 302}, {327, 265}, {241, 341}, {1917, 687}, {2991, 792}, {2573, 599}, {19, 674}, {3911, 1673},
    {872, 1559}, {2863, 558}, {929, 1766}, {839, 620}, {3893, 102}, {2178, 1619}, {3822, 899}, {378, 1048},
    {1178, 100}, {2599, 901}, {3416, 143}, {2961, 1605}, {611, 1384}, {3113, 885}, {2597, 1830}, {2586, 1286},
    {161, 906}, {1429, 134}, {742, 1025}, {1625, 1651}, {1187, 706}, {1787, 1009}, {22, 987}, {3640, 43},
    {3756, 882}, {776, 392}, {1724, 1642}, {198, 1810}, {3950, 1558}
}

local data_points = {}
for i, point in ipairs(raw_data) do
    table.insert(data_points, Point.new(point[1], point[2], i))
end

tsp(data_points)

