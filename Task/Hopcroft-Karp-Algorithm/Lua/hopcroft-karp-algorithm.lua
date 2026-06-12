#!/usr/bin/env lua

-- Representation of a bipartite graph
-- Vertices in the left partition, U, are numbered from 1 to m,
-- and vertices in the right partition, V, are numbered 1 to n.
local BipartiteGraph = {}
BipartiteGraph.__index = BipartiteGraph

function BipartiteGraph:new(m, n)
    local self = {
        m = m,
        n = n,
        adjacency_lists = {},
        pair_u = {},
        pair_v = {},
        levels = {},
        NIL = 0,
        INFINITY = 999999999
    }

    -- Initialize adjacency lists
    for u = 1, m do
        self.adjacency_lists[u] = {}
    end

    -- Initialize pairs
    for u = 1, m do
        self.pair_u[u] = self.NIL
    end
    for v = 1, n do
        self.pair_v[v] = self.NIL
    end

    -- Initialize levels
    for u = 1, m do
        self.levels[u] = self.INFINITY
    end

    setmetatable(self, BipartiteGraph)
    return self
end

function BipartiteGraph:add_edge(u, v)
    if u >= 1 and u <= self.m and v >= 1 and v <= self.n then
        table.insert(self.adjacency_lists[u], v)
    else
        error("Attempt to add an edge (" .. u .. ", " .. v .. ") which is out of bounds")
    end
end

-- Return the matching size of the bipartite graph
function BipartiteGraph:hopcroft_karp_algorithm()
    -- Reset pairs
    for u = 1, self.m do
        self.pair_u[u] = self.NIL
    end
    for v = 1, self.n do
        self.pair_v[v] = self.NIL
    end

    local matching_size = 0

    while self:breadth_first_search() do
        for u = 1, self.m do
            if self.pair_u[u] == self.NIL and self:depth_first_search(u) then
                -- vertex u is free and an augmenting path starting
                -- from u has been found by the depth first search
                matching_size = matching_size + 1
            end
        end
    end

    return matching_size
end

-- Determines whether there exists an augmenting path starting from a free vertex in U.
-- Return true if an augmenting path could exist, otherwise false.
function BipartiteGraph:breadth_first_search()
    local queue = {}

    -- Initialize 'levels' for the vertices in U
    for u = 1, self.m do
        if self.pair_u[u] == self.NIL then
            -- If u is a free vertex, its level is 0 and it is added to the queue
            self.levels[u] = 0
            table.insert(queue, u)
        else
            -- Otherwise, set 'levels' to infinity
            self.levels[u] = self.INFINITY
        end
    end

    -- The 'level' to the NIL node represents the length of the shortest augmenting path
    self.levels[self.NIL] = self.INFINITY

    local queue_front = 1
    local queue_back = #queue

    while queue_front <= queue_back do
        local u = queue[queue_front]
        queue_front = queue_front + 1

        if self.levels[u] < self.levels[self.NIL] then
            -- The path through u could lead to a shorter augmenting path
            for _, v in ipairs(self.adjacency_lists[u]) do
                -- Explore the neighbours v of u in V
                local matched_u = self.pair_v[v]
                if self.levels[matched_u] == self.INFINITY then
                    -- The matched vertex has not been visited yet
                    self.levels[matched_u] = self.levels[u] + 1
                    queue_back = queue_back + 1
                    queue[queue_back] = matched_u -- Enqueue the matched vertex to explore it further
                end
            end
        end
    end

    -- An augmenting path from the initial free vertices was found if levels[NIL] is not INFINITY
    return self.levels[self.NIL] ~= self.INFINITY
end

-- Determine whether the shortest path from vertex u in U found by breadth_first_search() can be augmented.
-- Return true if an augmenting path was found starting from u, otherwise false.
function BipartiteGraph:depth_first_search(u)
    if u ~= self.NIL then
        for _, v in ipairs(self.adjacency_lists[u]) do
            -- Explore neighbours v of u in V
            local matched_u = self.pair_v[v]
            -- Check whether the edge (u, v) leads to a vertex matched_u
            -- such that the path u -> v -> matched_u is part of a shortest augmenting path
            if self.levels[matched_u] == self.levels[u] + 1 then
                if self:depth_first_search(matched_u) then
                    -- An augmenting path is found starting from 'matched_u'
                    self.pair_v[v] = u -- Match v with u,
                    self.pair_u[u] = v -- and u with v
                    return true
                end
            end
        end

        -- No augmenting path was found starting from vertex u through any of its neighbours v,
        -- so remove u from the depth first search phase of the algorithm
        self.levels[u] = self.INFINITY
        return false
    end

    return true
end

function test_value(test_number, m, n, edges, expected_result)
    local graph = BipartiteGraph:new(m, n)

    for _, edge in ipairs(edges) do
        graph:add_edge(edge.from, edge.to)
    end

    local result = graph:hopcroft_karp_algorithm()
    print("Test " .. test_number .. ": Result = " .. result .. ", Expected = " .. expected_result)

    if result == expected_result then
        return 1
    end

    print("Test " .. test_number .. " failed.")
    return 0
end

-- Main execution
print("Running tests:")
local success_count = 0

-- Test Case 1
success_count = success_count + test_value(1, 3, 5, {{from = 1, to = 4}}, 1)

-- Test Case 2
success_count = success_count + test_value(2, 6, 6, {
    {from = 1, to = 4},
    {from = 1, to = 5},
    {from = 5, to = 1}
}, 2)

-- Test Case 3: Complete Bipartite Graph K(3, 3)
local edges = {}
for i = 1, 3 do
    for j = 1, 3 do
        table.insert(edges, {from = i, to = j})
    end
end
success_count = success_count + test_value(3, 3, 3, edges, 3)

-- Test Case 4: No edges
success_count = success_count + test_value(4, 2, 2, {}, 0)

-- Test Case 5
edges = {
    {from = 1, to = 1},
    {from = 1, to = 3},
    {from = 2, to = 3},
    {from = 3, to = 4},
    {from = 4, to = 3},
    {from = 4, to = 2}
}
success_count = success_count + test_value(5, 4, 4, edges, 4)

if success_count == 5 then
    print("All tests passed.")
end
