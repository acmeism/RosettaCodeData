local count = 0
local box = { }
local boxmt = { __index = box }
function box:tellSecret ()
    return self.secret
end

local M = { }
function M.new ()
    count = count + 1
    return setmetatable({ secret = count, contents = count % 2 == 0 and "rabbit" or "rock" }, boxmt)
end
function M.count ()
    return count
end
return M
