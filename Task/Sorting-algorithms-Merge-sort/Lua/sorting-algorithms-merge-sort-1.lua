local function merge(left_container, left_container_begin, left_container_end, right_container, right_container_begin, right_container_end, result_container, result_container_begin, comparator)
	while left_container_begin <= left_container_end do
		if right_container_begin > right_container_end then
			for i = left_container_begin, left_container_end do
				result_container[result_container_begin] = left_container[i]
				result_container_begin = result_container_begin + 1
			end

			return
		end

		if comparator(right_container[right_container_begin], left_container[left_container_begin]) then
			result_container[result_container_begin] = right_container[right_container_begin]
			right_container_begin = right_container_begin + 1
		else
			result_container[result_container_begin] = left_container[left_container_begin]
			left_container_begin = left_container_begin + 1
		end

		result_container_begin = result_container_begin + 1
	end

	for i = right_container_begin, right_container_end do
		result_container[result_container_begin] = right_container[i]
		result_container_begin = result_container_begin + 1
	end
end

local function mergesort_impl(container, container_begin, container_end, comparator)
	local range_length = (container_end - container_begin) + 1
	if range_length < 2 then return end
	local copy = {}
	local copy_len = 0

	for it = container_begin, container_end do
		copy_len = copy_len + 1
		copy[copy_len] = container[it]
	end

	local middle = bit.rshift(range_length, 1) -- or math.floor(range_length / 2)
	mergesort_impl(copy, 1, middle, comparator)
	mergesort_impl(copy, middle + 1, copy_len, comparator)
	merge(copy, 1, middle, copy, middle + 1, copy_len, container, container_begin, comparator)
end

local function mergesort_default_comparator(a, b)
	return a < b
end

function table.mergesort(container, comparator)
	if not comparator then
		comparator = mergesort_default_comparator
	end

	mergesort_impl(container, 1, #container, comparator)
end
