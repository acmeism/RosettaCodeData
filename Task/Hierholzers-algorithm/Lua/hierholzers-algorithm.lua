function print_circuit(adjacency_list)
    if #adjacency_list == 0 then
        return
    end

    local path = {}
    local circuit = {}
    local current_vertex = 1 -- Lua arrays are 1-based
    table.insert(path, current_vertex)

    while #path > 0 do
        if #adjacency_list[current_vertex] > 0 then
            table.insert(path, current_vertex)
            local next_vertex = table.remove(adjacency_list[current_vertex])
            current_vertex = next_vertex
        else
            table.insert(circuit, current_vertex)
            current_vertex = table.remove(path)
        end
    end

    -- Print the circuit
    for i = #circuit, 1, -1 do
        io.write(circuit[i])
        if i ~= 1 then
            io.write(" => ")
        end
    end
    print()
end

local adjacency_list1 = {
    {2},
    {3},
    {1}
}

print_circuit(adjacency_list1)

local adjacency_list2 = {
    {2, 7},
    {3},
    {1, 4},
    {5},
    {3, 6},
    {1},
    {5}
}

print_circuit(adjacency_list2)

