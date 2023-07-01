function write_array(a)
    io.write("[")
    for i=0,#a do
        if i>0 then
            io.write(", ")
        end
        io.write(tostring(a[i]))
    end
    io.write("]")
end

function kosaraju(g)
    -- 1. For each vertex u of the graph, mark u as unvisited. Let l be empty.
    local size = #g

    local vis = {}
    for i=0,size do
        -- all false by default
        vis[i] = false
    end

    local l = {}
    for i=0,size do
        -- all zero by default
        l[i] = 0
    end

    local x = size+1  -- index for filling l in reverse order

    local t = {}    -- transpose graph

    -- Recursive subroutine 'visit'
    function visit(u)
        if not vis[u] then
            vis[u] = true
            for i=0,#g[u] do
                local v = g[u][i]
                visit(v)
                if t[v] then
                    local a = t[v]
                    a[#a+1] = u
                else
                    t[v] = {[0]=u}
                end
            end
            x = x - 1
            l[x] = u
        end
    end

    -- 2. For each vertex u of the graph do visit(u)
    for i=0,#g do
        visit(i)
    end
    local c = {}
    for i=0,size do
        -- used for component assignment
        c[i] = 0
    end

    -- Recursive subroutine 'assign'
    function assign(u, root)
        if vis[u] then  -- repurpose vis to mean 'unassigned'
            vis[u] = false
            c[u] = root
            for i=0,#t[u] do
                local v = t[u][i]
                assign(v, root)
            end
        end
    end

    -- 3: For each element u of l in order, do assign(u, u)
    for i=0,#l do
        local u = l[i]
        assign(u, u)
    end

    return c
end

-- main
local g = {
    [0]={[0]=1},
    [1]={[0]=2},
    [2]={[0]=0},
    [3]={[0]=1, [1]=2, [2]=4},
    [4]={[0]=3, [1]=5},
    [5]={[0]=2, [1]=6},
    [6]={[0]=5},
    [7]={[0]=4, [1]=6, [2]=7},
}

write_array(kosaraju(g))
print()
