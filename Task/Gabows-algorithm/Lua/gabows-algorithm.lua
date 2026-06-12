-- Edge representation
local Edge = {}
Edge.__index = Edge

function Edge:new(from, to)
    local obj = {
        from = from,
        to = to
    }
    setmetatable(obj, Edge)
    return obj
end

function Edge:getFrom()
    return self.from
end

function Edge:getTo()
    return self.to
end

-- Digraph representation
local Digraph = {}
Digraph.__index = Digraph

function Digraph:new(vertexCount)
    if vertexCount < 0 then
        error("Number of vertices must be non-negative")
    end

    local obj = {
        vertexCount = vertexCount,
        edgeCount = 0,
        adjacencyLists = {}
    }

    -- Initialize adjacency lists (Lua arrays are 1-indexed, but we'll use 0-based indexing)
    for i = 0, vertexCount - 1 do
        obj.adjacencyLists[i] = {}
    end

    setmetatable(obj, Digraph)
    return obj
end

function Digraph:addEdge(from, to)
    self:validateVertex(from)
    self:validateVertex(to)
    table.insert(self.adjacencyLists[from], to)
    self.edgeCount = self.edgeCount + 1
end

function Digraph:toString()
    local result = "Digraph has " .. self.vertexCount .. " vertices and " .. self.edgeCount .. " edges\nAdjacency lists:\n"

    for vertex = 0, self.vertexCount - 1 do
        local prefix = vertex < 10 and (" " .. vertex .. ": ") or (vertex .. ": ")

        -- Sort the adjacency list
        local sorted = {}
        for _, v in ipairs(self.adjacencyLists[vertex]) do
            table.insert(sorted, v)
        end
        table.sort(sorted)

        result = result .. prefix .. table.concat(sorted, " ") .. "\n"
    end
    return result
end

function Digraph:getVertexCount()
    return self.vertexCount
end

function Digraph:getEdgeCount()
    return self.edgeCount
end

function Digraph:getAdjacencyList(vertex)
    self:validateVertex(vertex)
    return self.adjacencyLists[vertex]
end

function Digraph:validateVertex(vertex)
    if vertex < 0 or vertex >= self.vertexCount then
        error("Vertex must be between 0 and " .. (self.vertexCount - 1) .. ": " .. vertex)
    end
end

-- Stack implementation
local Stack = {}
Stack.__index = Stack

function Stack:new()
    local obj = {
        items = {}
    }
    setmetatable(obj, Stack)
    return obj
end

function Stack:push(item)
    table.insert(self.items, item)
end

function Stack:pop()
    return table.remove(self.items)
end

function Stack:peek()
    if #self.items > 0 then
        return self.items[#self.items]
    end
    return nil
end

function Stack:isEmpty()
    return #self.items == 0
end

function Stack:size()
    return #self.items
end

-- Gabow's Strongly Connected Components Algorithm
local GabowSCC = {}
GabowSCC.__index = GabowSCC

local NONE = -1

function GabowSCC:new(digraph)
    local obj = {
        visited = {},
        componentIDs = {},
        preorders = {},
        preorderCount = 0,
        sccCount = 0,
        visitedVerticesStack = Stack:new(),
        auxiliaryStack = Stack:new(),
        digraph = digraph
    }

    setmetatable(obj, GabowSCC)

    -- Initialize arrays
    local vertexCount = digraph:getVertexCount()
    for i = 0, vertexCount - 1 do
        obj.visited[i] = false
        obj.componentIDs[i] = NONE
        obj.preorders[i] = NONE
    end

    -- Run DFS for each unvisited vertex
    for vertex = 0, vertexCount - 1 do
        if not obj.visited[vertex] then
            obj:depthFirstSearch(vertex)
        end
    end

    return obj
end

function GabowSCC:getComponents()
    local components = {}

    -- Initialize component arrays
    for i = 0, self.sccCount - 1 do
        components[i] = {}
    end

    local vertexCount = self.digraph:getVertexCount()
    for vertex = 0, vertexCount - 1 do
        local componentID = self:getComponentID(vertex)
        if componentID ~= NONE then
            table.insert(components[componentID], vertex)
        else
            error("Warning: Vertex " .. vertex .. " has no SCC ID assigned.")
        end
    end

    return components
end

function GabowSCC:isStronglyConnected(v, w)
    self:validateVertex(v)
    self:validateVertex(w)
    return self.componentIDs[v] ~= NONE and
           self.componentIDs[v] == self.componentIDs[w]
end

function GabowSCC:getComponentID(vertex)
    self:validateVertex(vertex)
    return self.componentIDs[vertex]
end

function GabowSCC:getStronglyConnectedComponentCount()
    return self.sccCount
end

function GabowSCC:depthFirstSearch(vertex)
    self.visited[vertex] = true
    self.preorders[vertex] = self.preorderCount
    self.preorderCount = self.preorderCount + 1
    self.visitedVerticesStack:push(vertex)
    self.auxiliaryStack:push(vertex)

    local adjList = self.digraph:getAdjacencyList(vertex)
    for _, w in ipairs(adjList) do
        if not self.visited[w] then
            self:depthFirstSearch(w)
        elseif self.componentIDs[w] == NONE then
            while not self.auxiliaryStack:isEmpty() and
                  self.preorders[self.auxiliaryStack:peek()] > self.preorders[w] do
                self.auxiliaryStack:pop()
            end
        end
    end

    if not self.auxiliaryStack:isEmpty() and self.auxiliaryStack:peek() == vertex then
        self.auxiliaryStack:pop()

        while not self.visitedVerticesStack:isEmpty() do
            local w = self.visitedVerticesStack:pop()
            self.componentIDs[w] = self.sccCount
            if w == vertex then
                break
            end
        end
        self.sccCount = self.sccCount + 1
    end
end

function GabowSCC:validateVertex(vertex)
    local vertexCount = self.digraph:getVertexCount()
    if vertex < 0 or vertex >= vertexCount then
        error("Vertex " .. vertex .. " is not between 0 and " .. (vertexCount - 1))
    end
end

-- Main execution
local function main()
    -- Create edges
    local edges = {
        Edge:new(4, 2), Edge:new(2, 3), Edge:new(3, 2), Edge:new(6, 0), Edge:new(0, 1),
        Edge:new(2, 0), Edge:new(11, 12), Edge:new(12, 9), Edge:new(9, 10), Edge:new(9, 11),
        Edge:new(8, 9), Edge:new(10, 12), Edge:new(0, 5), Edge:new(5, 4), Edge:new(3, 5),
        Edge:new(6, 4), Edge:new(6, 9), Edge:new(7, 6), Edge:new(7, 8), Edge:new(8, 7),
        Edge:new(5, 3), Edge:new(0, 6)
    }

    -- Create digraph
    local digraph = Digraph:new(13)

    -- Add edges
    for _, edge in ipairs(edges) do
        digraph:addEdge(edge:getFrom(), edge:getTo())
    end

    print("Constructed digraph:")
    print(digraph:toString())

    -- Run Gabow's algorithm
    local gabowSCC = GabowSCC:new(digraph)
    print("It has " .. gabowSCC:getStronglyConnectedComponentCount() .. " strongly connected components.")

    -- Get components
    local components = gabowSCC:getComponents()
    print("\nComponents:")
    for i = 0, gabowSCC:getStronglyConnectedComponentCount() - 1 do
        local component = components[i]
        print("Component " .. i .. ": " .. table.concat(component, " "))
    end

    -- Example connectivity checks
    print("\nExample connectivity checks:")
    print("Vertices 0 and 3 strongly connected? " ..
          (gabowSCC:isStronglyConnected(0, 3) and "true" or "false"))
    print("Vertices 0 and 7 strongly connected? " ..
          (gabowSCC:isStronglyConnected(0, 7) and "true" or "false"))
    print("Vertices 9 and 12 strongly connected? " ..
          (gabowSCC:isStronglyConnected(9, 12) and "true" or "false"))
    print("Component ID of vertex 5: " .. gabowSCC:getComponentID(5))
    print("Component ID of vertex 8: " .. gabowSCC:getComponentID(8))
end

-- Run the main function
main()
