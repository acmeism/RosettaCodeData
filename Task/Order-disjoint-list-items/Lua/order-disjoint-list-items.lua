-- Split str on any space characters and return as a table
function split (str)
    local t = {}
    for word in str:gmatch("%S+") do table.insert(t, word) end
    return t
end

-- Order disjoint list items
function orderList (dataStr, orderStr)
    local data, order = split(dataStr), split(orderStr)
    for orderPos, orderWord in pairs(order) do
        for dataPos, dataWord in pairs(data) do
            if dataWord == orderWord then
                data[dataPos] = false
                break
            end
        end
    end
    local orderPos = 1
    for dataPos, dataWord in pairs(data) do
        if not dataWord then
            data[dataPos] = order[orderPos]
            orderPos = orderPos + 1
            if orderPos > #order then return data end
        end
    end
    return data
end

-- Main procedure
local testCases = {
    {'the cat sat on the mat', 'mat cat'},
    {'the cat sat on the mat', 'cat mat'},
    {'A B C A B C A B C'     , 'C A C A'},
    {'A B C A B D A B E'     , 'E A D A'},
    {'A B'                   , 'B'},
    {'A B'                   , 'B A'},
    {'A B B A'               , 'B A'}
}
for _, example in pairs(testCases) do
    print(table.concat(orderList(unpack(example)), " "))
end
