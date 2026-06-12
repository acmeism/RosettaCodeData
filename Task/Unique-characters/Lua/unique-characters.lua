local strings = {"133252abcdeeffd",  "a6789798st",  "yxcdfgxcyz"}
unpack = unpack or table.unpack -- compatibility for all Lua versions

local map = {}
for i, str in ipairs (strings) do
	
	for i=1, string.len(str) do
		local char = string.sub(str,i,i)
		if map[char] == nil then
			map[char] = true
		else
			map[char] = false
		end
	end
	
end

local list = {}
for char, bool in pairs (map) do
	if bool then
		table.insert (list, char)
	end
end
table.sort (list)
print (unpack (list))
