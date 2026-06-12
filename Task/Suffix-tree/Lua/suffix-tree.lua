#!/usr/bin/env lua

-- Node class implementation
local function Node_new()
    return {
        sub = "",
        ch = {}
    }
end

-- Forward declaration
local SuffixTree_addSuffix

-- SuffixTree addSuffix implementation
SuffixTree_addSuffix = function(self, suf)
    local nodes = self.nodes
    local n = 1  -- Lua arrays are 1-indexed
    local i = 1
    local suf_len = string.len(suf)

    while i <= suf_len do
        local b = string.sub(suf, i, i)
        local current_node = nodes[n]
        local children = current_node.ch
        local x2 = 0
        local n2 = -1

        -- Find matching child
        local found = false
        for idx, child_idx in ipairs(children) do
            local child_node = nodes[child_idx]
            local child_sub = child_node.sub
            if string.sub(child_sub, 1, 1) == b then
                n2 = child_idx
                x2 = idx
                found = true
                break
            end
        end

        if not found then
            -- No matching child, remainder of suf becomes new node
            n2 = #nodes + 1
            local temp = Node_new()
            temp.sub = string.sub(suf, i)
            table.insert(nodes, temp)

            -- Update parent's children list
            local parent_node = nodes[n]
            table.insert(parent_node.ch, n2)

            return self
        end

        -- Find prefix of remaining suffix in common with child
        local child_node = nodes[n2]
        local sub2 = child_node.sub
        local j = 1
        local sub2_len = string.len(sub2)

        while j <= sub2_len do
            if i + j - 1 > suf_len or string.sub(suf, i + j - 1, i + j - 1) ~= string.sub(sub2, j, j) then
                -- Split n2
                local n3 = n2
                -- New node for the part in common
                n2 = #nodes + 1
                local temp = Node_new()
                temp.sub = string.sub(sub2, 1, j - 1)
                temp.ch = {n3}
                table.insert(nodes, temp)

                -- Old node loses the part in common
                local old_node = nodes[n3]
                old_node.sub = string.sub(sub2, j)

                -- Update parent's child reference
                local parent_node = nodes[n]
                parent_node.ch[x2] = n2

                break
            end
            j = j + 1
        end

        i = i + j - 1  -- advance past part in common
        n = n2         -- continue down the tree
    end

    return self
end

-- SuffixTree constructor
local function SuffixTree_new(str)
    local self = {
        nodes = {}
    }

    -- Add root node
    table.insert(self.nodes, Node_new())

    -- Add all suffixes
    local len = string.len(str)
    for i = 1, len do
        local suffix = string.sub(str, i)
        self = SuffixTree_addSuffix(self, suffix)
    end

    return self
end

local function SuffixTree_visualize_f(self, n, pre)
    local nodes = self.nodes
    local current_node = nodes[n]
    local children = current_node.ch
    local node_sub = current_node.sub

    if #children == 0 then
        print("- " .. node_sub)
        return
    end

    print("┐ " .. node_sub)

    local children_count = #children
    for i = 1, children_count - 1 do
        local c = children[i]
        io.write(pre .. "├─")
        SuffixTree_visualize_f(self, c, pre .. "│ ")
    end

    io.write(pre .. "└─")
    local last_child = children[children_count]
    SuffixTree_visualize_f(self, last_child, pre .. "  ")
end

local function SuffixTree_visualize(self)
    local nodes = self.nodes

    if #nodes == 0 then
        print("<empty>")
        return
    end
    SuffixTree_visualize_f(self, 1, "")
end

-- Main execution
local tree = SuffixTree_new("banana$")
SuffixTree_visualize(tree)
