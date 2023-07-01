local function factors (n)
	local f, i = {1, n}, 2
	while true do
		local j = n//i -- floor division by Lua 5.3
		if j < i then
			break
		elseif j == i and i * j == n then
			table.insert (f, i)
			break
		elseif i * j == n then
			table.insert (f, i)
			table.insert (f, j)
		end
		i = i + 1
	end
	return f
end

local function sum (f)
	local s = 0
	for i, value in ipairs (f) do
		s = s + value
	end
	return s
end

local arithmetic_count = 1
local composite_count = 0
local hundr = {1}

for n = 2, 1228663 do
	local f = factors (n)
	local s = sum (f)
	local l = #f
	if (s/l)%1 == 0 then
		arithmetic_count = arithmetic_count + 1
		if l > 2 then
			composite_count = composite_count + 1
		end
		if arithmetic_count <= 100 then
			table.insert (hundr, n)
		end
		if arithmetic_count == 100 then
			for i = 0, 9 do
				print (table.concat(hundr, ',	', 10*i+1, 10*i+10))
			end
		elseif arithmetic_count == 1000
			or arithmetic_count == 10000
			or arithmetic_count == 100000 then
			print (arithmetic_count..'th arithmetic number is '..(n))
			print ('Number of composite arithmetic numbers <= '..(n)..': '..composite_count)
		elseif arithmetic_count == 1000000 then
			print (arithmetic_count..'th arithmetic number is '..(n))
			print ('Number of composite arithmetic numbers <= '..(n)..': '..composite_count)
			return
		end
	end
end
