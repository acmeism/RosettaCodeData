do
	local function lower_bound(container, container_begin, container_end, value, comparator)
		local count = container_end - container_begin + 1

		while count > 0 do
			local half = bit.rshift(count, 1) -- or math.floor(count / 2)
			local middle = container_begin + half

			if comparator(container[middle], value) then
				container_begin = middle + 1
				count = count - half - 1
			else
				count = half
			end
		end

		return container_begin
	end

	local function binary_insertion_sort_impl(container, comparator)
		for i = 2, #container do
			local j = i - 1
			local selected = container[i]
			local loc = lower_bound(container, 1, j, selected, comparator)

			while j >= loc do
				container[j + 1] = container[j]
				j = j - 1
			end

			container[j + 1] = selected
		end
	end

	local function binary_insertion_sort_comparator(a, b)
		return a < b
	end

	function table.bininsertionsort(container, comparator)
		if not comparator then
			comparator = binary_insertion_sort_comparator
		end

		binary_insertion_sort_impl(container, comparator)
	end
end
