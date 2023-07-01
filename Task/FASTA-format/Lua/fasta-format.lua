local file = io.open("input.txt","r")
local data = file:read("*a")
file:close()

local output = {}
local key = nil

-- iterate through lines
for line in data:gmatch("(.-)\r?\n") do
	if line:match("%s") then
		error("line contained space")
	elseif line:sub(1,1) == ">" then
		key = line:sub(2)
		-- if key already exists, append to the previous input
		output[key] = output[key] or ""
	elseif key ~= nil then
		output[key] = output[key] .. line
	end
end

-- print result
for k,v in pairs(output) do
	print(k..": "..v)
end
