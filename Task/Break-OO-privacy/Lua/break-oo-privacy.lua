local function Counter()
	-- These two variables are "private" to this function and can normally
	-- only be accessed from within this scope, including by any function
	-- created inside here.
	local counter = {}
	local count   = 0

	function counter:increment()
		-- 'count' is an upvalue here and can thus be accessed through the
		-- debug library, as long as we have a reference to this function.
		count = count + 1
	end

	return counter
end

-- Create a counter object and try to access the local 'count' variable.
local counter = Counter()

for i = 1, math.huge do
	local name, value = debug.getupvalue(counter.increment, i)
	if not name then  break  end -- No more upvalues.

	if name == "count" then
		print("Found 'count', which is "..tostring(value))
		-- If the 'counter.increment' function didn't access 'count'
		-- directly then we would never get here.
		break
	end
end
