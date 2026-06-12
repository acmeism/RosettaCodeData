local edges = {
    { start = "a", end_ = "b" },
    { start = "b", end_ = "a" },
    { start = "a", end_ = "c" },
    { start = "c", end_ = "a" },
    { start = "b", end_ = "c" },
    { start = "c", end_ = "b" },
    { start = "d", end_ = "e" },
    { start = "e", end_ = "d" },
    { start = "d", end_ = "f" },
    { start = "f", end_ = "d" },
    { start = "e", end_ = "f" },
    { start = "f", end_ = "e" },
}

-- Simple serialization function for table display
function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
        for k, v in pairs(obj) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
        end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

function bron_kerbosch(current_clique, candidates, processed_vertices, graph, cliques)
    if next(candidates) == nil and next(processed_vertices) == nil then
        if #current_clique > 2 then
            local new_clique = {}
            for _, v in ipairs(current_clique) do
                table.insert(new_clique, v)
            end
            table.insert(cliques, new_clique)
        end
        return
    end

    -- Select a pivot vertex from 'candidates' union 'processedVertices' with the maximum degree
    local union = {}
    for k, v in pairs(candidates) do union[k] = v end
    for k, v in pairs(processed_vertices) do union[k] = v end
    local pivot = max_degree_vertex(union, graph)

    -- 'possibles' are vertices in 'candidates' that are not neighbors of the 'pivot'
    local possibles = {}
    for k, v in pairs(candidates) do possibles[k] = v end

    if graph[pivot] then
        for _, neighbor in ipairs(graph[pivot]) do
            possibles[neighbor] = nil
        end
    end

    for vertex, _ in pairs(possibles) do
        -- Create a new clique including 'vertex'
        local new_clique = {}
        for _, v in ipairs(current_clique) do
            table.insert(new_clique, v)
        end
        table.insert(new_clique, vertex)

        -- 'newCandidates' are the members of 'candidates' that are neighbors of 'vertex'
        local neighbors = {}
        if graph[vertex] then
            for _, neighbor in ipairs(graph[vertex]) do
                neighbors[neighbor] = true
            end
        end

        local new_candidates = {}
        for candidate, _ in pairs(candidates) do
            if neighbors[candidate] then
                new_candidates[candidate] = true
            end
        end

        -- 'newProcessedVertices' are members of 'processedVertices' that are neighbors of 'vertex'
        local new_processed_vertices = {}
        for processed, _ in pairs(processed_vertices) do
            if neighbors[processed] then
                new_processed_vertices[processed] = true
            end
        end

        -- Recursive call with the updated sets
        bron_kerbosch(new_clique, new_candidates, new_processed_vertices, graph, cliques)

        -- Move 'vertex' from 'candidates' to 'processedVertices'
        candidates[vertex] = nil
        processed_vertices[vertex] = true
    end
end

function max_degree_vertex(vertices, graph)
    local max_vertex, max_degree = nil, -1

    for vertex, _ in pairs(vertices) do
        local degree = 0
        if graph[vertex] then
            degree = #graph[vertex]
        end
        if degree > max_degree then
            max_degree = degree
            max_vertex = vertex
        end
    end

    return max_vertex
end

function list_comparator(list1, list2)
    local min_length = math.min(#list1, #list2)

    for i = 1, min_length do
        if list1[i] < list2[i] then
            return -1
        elseif list1[i] > list2[i] then
            return 1
        end
    end

    if #list1 < #list2 then
        return -1
    elseif #list1 > #list2 then
        return 1
    else
        return 0
    end
end

-- Build the graph as an adjacency list
local graph = {}
for _, edge in ipairs(edges) do
    if not graph[edge.start] then
        graph[edge.start] = {}
    end
    table.insert(graph[edge.start], edge.end_)
end

-- Initialize current clique, candidates, and processed vertices
local current_clique = {}
local candidates = {}
for vertex, _ in pairs(graph) do
    candidates[vertex] = true
end
local processed_vertices = {}

-- Execute the Bron-Kerbosch algorithm to collect the cliques
local cliques = {}
bron_kerbosch(current_clique, candidates, processed_vertices, graph, cliques)

-- Sort the cliques for consistent display
table.sort(cliques, function(a, b) return list_comparator(a, b) < 0 end)

-- Display the cliques
print(serialize(cliques))
