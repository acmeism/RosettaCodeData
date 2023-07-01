-- This concept is relevant to tables in Lua
local table1 = {1,2,3}

-- The following will create a table of references to table1
local refTab = {}
for i = 1, 10 do refTab[i] = table1 end

-- Instead, tables should be copied using a function like this	
function copy (t)
    local new = {}
    for k, v in pairs(t) do new[k] = v end
    return new
end

-- Now we can create a table of independent copies of table1
local copyTab = {}
for i = 1, 10 do copyTab[i] = copy(table1) end
