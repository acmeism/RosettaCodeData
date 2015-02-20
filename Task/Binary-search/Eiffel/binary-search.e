class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		local
			a: ARRAY [INTEGER]
			keys: ARRAY [INTEGER]
		do
			a := <<0, 1, 4, 5, 6, 7, 8, 9,
			       12, 26, 45, 67, 78, 90,
			       98, 123, 211, 234, 456,
			       769, 865, 2345, 3215,
			       14345, 24324>>
			keys := <<0, 42, 45, 24324, 99999>>
			across keys as k loop
				if has_binary (a, k.item) then
					print ("The array has an element " + k.item.out)
				else
					print ("The array has NOT an element " + k.item.out)
				end
				print ("%N")
			end
		end

feature -- Search

	has_binary (a: ARRAY [INTEGER]; key: INTEGER): BOOLEAN
		-- Does `a[a.lower..a.upper]' include an element `key'?
		require
			is_sorted (a, a.lower, a.upper)
		local
			i: INTEGER
		do
			i := where_binary (a, key)
			if a.lower <= i and i <= a.upper then
				Result := True
			else
				Result := False
			end
		end

	where_binary (a: ARRAY [INTEGER]; key: INTEGER): INTEGER
		-- The index of an element `key' within `a[a.lower..a.upper]' if it exists.
		-- Otherwise an integer outside `[a.lower..a.upper]'
		require
			is_sorted (a, a.lower, a.upper)
		do
			Result := where_binary_range (a, key, a.lower, a.upper)
		end

	where_binary_range (a: ARRAY [INTEGER]; key: INTEGER; low, high: INTEGER): INTEGER
		-- The index of an element `key' within `a[low..high]' if it exists.
		-- Otherwise an integer outside `[low..high]'
		note
			source: "http://arxiv.org/abs/1211.4470"
		require
			is_sorted (a, low, high)
		local
			i, j, mid: INTEGER
		do
			if low > high then
				Result := low - 1
			else
				from
					i := low
					j := high
					mid := low
					Result := low - 1
				invariant
					low <= i and i <= mid + 1
					low <= mid and mid <= j and j <= high
					i <= j
					has (a, key, i, j) = has (a, key, low, high)
				until
					i >= j
				loop
					mid := i + (j - i) // 2
					if a [mid] < key then
						i := mid + 1
					else
						j := mid
					end
				variant
					j - i
				end
				if a [i] = key then
					Result := i
				end
			end
		ensure
			low <= Result and Result <= high implies a [Result] = key
			Result < low or Result > high implies not has (a, key, low, high)
		end

feature -- Implementation

	is_sorted (a: ARRAY [INTEGER]; low, high: INTEGER): BOOLEAN
		-- Is `a[low..high]' sorted in nondecreasing order?
		require
			a.lower <= low
			high <= a.upper
		do
			Result := across low |..| (high - 1) as i all a [i.item] <= a [i.item + 1] end
		end

	has (a: ARRAY [INTEGER]; key: INTEGER; low, high: INTEGER): BOOLEAN
		-- Is there an element `key' in `a[low..high]'?
		require
			a.lower <= low
			high <= a.upper
		do
			Result := across low |..| high as i some a [i.item] = key end
		end

end
