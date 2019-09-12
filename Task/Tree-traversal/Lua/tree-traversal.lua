-- Utility
local function append(t1, t2)
    for _, v in ipairs(t2) do
        table.insert(t1, v)
    end
end

-- Node class
local Node = {}
Node.__index = Node

function Node:order(order)
    local r = {}
    append(r, type(self[order[1]]) == "table" and self[order[1]]:order(order) or {self[order[1]]})
    append(r, type(self[order[2]]) == "table" and self[order[2]]:order(order) or {self[order[2]]})
    append(r, type(self[order[3]]) == "table" and self[order[3]]:order(order) or {self[order[3]]})
    return r
end

function Node:levelorder()
    local levelorder = {}
    local queue = {self}
    while next(queue) do
        local node = table.remove(queue, 1)
        table.insert(levelorder, node[1])
        table.insert(queue, node[2])
        table.insert(queue, node[3])
    end
    return levelorder
end

-- Node creator
local function new(value, left, right)
    return value and setmetatable({
        value,
        (type(left) == "table") and new(unpack(left)) or new(left),
        (type(right) == "table") and new(unpack(right)) or new(right),
        }, Node) or nil
end

-- Example
local tree = new(1, {2, {4, 7}, 5}, {3, {6, 8, 9}})
print("preorder:    " .. table.concat(tree:order({1, 2, 3}), " "))
print("inorder:     " .. table.concat(tree:order({2, 1, 3}), " "))
print("postorder:   " .. table.concat(tree:order({2, 3, 1}), " "))
print("level-order: " .. table.concat(tree:levelorder(), " "))
