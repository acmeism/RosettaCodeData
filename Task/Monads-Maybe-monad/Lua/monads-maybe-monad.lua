-- None is represented by an empty table.  Some is represented by any
-- array with one element.  You SHOULD NOT compare maybe values with the
-- Lua operator == because it will give incorrect results.  Use the
-- functions isMaybe(), isNone(), and isSome().

-- define once for efficiency, to avoid many different empty tables
local NONE = {}

local function unit(x) return { x } end
local Some = unit
local function isNone(mb) return #mb == 0 end
local function isSome(mb) return #mb == 1 end
local function isMaybe(mb) return isNone(mb) or isSome(mb) end

-- inverse of Some(), extract the value from the maybe; get(Some(x)) === x
local function get(mb) return mb[1] end

function maybeToStr(mb)
	return isNone(mb) and "None" or ("Some " .. tostring(get(mb)))
end

local function bind(mb, ...)  -- monadic bind for multiple functions
	local acc = mb
	for _, fun in ipairs({...}) do  -- fun should be a monadic function
		assert(type(fun) == "function")
		if isNone(acc) then return NONE
		else acc = fun(get(acc)) end
	end
	return acc
end

local function fmap(mb, ...)  -- monadic fmap for multiple functions
	local acc = mb
	for _, fun in ipairs({...}) do  -- fun should be a regular function
		assert(type(fun) == "function")
		if isNone(acc) then return NONE
		else acc = Some(fun(get(acc))) end
	end
	return acc
end
-- ^^^ End of generic maybe monad functionality ^^^

--- vvv Start of example code vvv

local function time2(x) return x * 2 end
local function plus1(x) return x + 1 end

local answer
answer = fmap(Some(3), time2, plus1, time2)
assert(get(answer)==14)

answer = fmap(NONE, time2, plus1, time2)
assert(isNone(answer))

local function safeReciprocal(x)
	if x ~= 0 then return Some(1/x) else return NONE end
end
local function safeRoot(x)
	if x >= 0 then return Some(math.sqrt(x)) else return NONE end
end
local function safeLog(x)
	if x > 0 then return Some(math.log(x)) else return NONE end
end
local function safeComputation(x)
	return bind(safeReciprocal(x), safeRoot, safeLog)
end

local function map(func, table)
	local result = {}
	for key, val in pairs(table) do
		result[key] = func(val)
	end
	return result
end

local inList = {-2, -1, -0.5, 0, math.exp (-1), 1, 2, math.exp (1), 3, 4, 5}
print("input:", table.concat(map(tostring, inList), ",  "), "\n")

local outList = map(safeComputation, inList)
print("output:", table.concat(map(maybeToStr, outList), ",  "), "\n")
