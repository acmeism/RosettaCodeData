-- First 20 antiprimes.

function count_factors(number)
	local count = 0
	for attempt = 1, number do
		local remainder = number % attempt
		if remainder == 0 then
			count = count + 1
		end
	end
	return count
end

function antiprimes(goal)
	local list, number, mostFactors = {}, 1, 0
	while #list < goal do
		local factors = count_factors(number)
		if factors > mostFactors then
			table.insert(list, number)
			mostFactors = factors
		end
		number = number + 1
	end
	return list
end

function recite(list)
	for index, item in ipairs(list) do
		print(item)
	end
end

print("The first 20 antiprimes:")
recite(antiprimes(20))
print("Done.")
