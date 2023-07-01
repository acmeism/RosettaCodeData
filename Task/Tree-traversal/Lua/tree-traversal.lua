local function depth_first(tr, a, b, c, flat_list)
	for _, val in ipairs({a, b, c}) do
		if type(tr[val]) == "table" then
			depth_first(tr[val], a, b, c, flat_list)
		elseif type(tr[val]) ~= "nil" then
			table.insert(flat_list, tr[val])
		end -- if
	end -- for
	return flat_list
end
local function flatten_pre_order(tr)  return depth_first(tr, 1, 2, 3, {}) end
local function flatten_in_order(tr)   return depth_first(tr, 2, 1, 3, {}) end
local function flatten_post_order(tr) return depth_first(tr, 2, 3, 1, {}) end

local function flatten_level_order(tr)
    local flat_list, queue = {}, {tr}
    while next(queue) do  -- while queue is not empty
        local node = table.remove(queue, 1)  -- dequeue
		  if type(node) == "table" then
			  table.insert(flat_list, node[1])
			  table.insert(queue, node[2])  -- enqueue
			  table.insert(queue, node[3])  -- enqueue
		  else
			  table.insert(flat_list, node)
		  end  -- if
    end  -- while
    return flat_list
end

-- Example
local tree = {1, {2, {4, 7}, 5}, {3, {6, 8, 9}}}
print("Pre order:   " .. table.concat(flatten_pre_order(tree), " "))
print("In order:    " .. table.concat(flatten_in_order(tree), " "))
print("Post order:  " .. table.concat(flatten_post_order(tree), " "))
print("Level order: " .. table.concat(flatten_level_order(tree), " "))
