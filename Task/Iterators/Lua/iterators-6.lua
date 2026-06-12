-- linked_list.lua
---@class LinkedList
---@field value any
---@field next LinkedList?
local LinkedList = { __name = "LinkedList" }
LinkedList.__index = LinkedList

---@param values any[]
function LinkedList.from_list(values)
    local list = nil
    for i = #values, 1, -1 do
        list = LinkedList.new(values[i], list)
    end
    return list
end

---@param next LinkedList?
---@return LinkedList
function LinkedList.new(value, next)
    return setmetatable({ value = value, next = next }, LinkedList)
end

local function linked_list_pairs(root, node)
    if not node then
        return root, root.value
    elseif node.next then
        return node.next, node.next.value
    end
end

function LinkedList:pairs()
    return linked_list_pairs, self, nil
end

return LinkedList
