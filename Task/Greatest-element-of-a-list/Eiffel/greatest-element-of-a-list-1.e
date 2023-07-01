class
	GREATEST_ELEMENT [G -> COMPARABLE]

create
	make

feature {NONE} --Implementation

	is_max (element: G maximum: G): BOOLEAN
		do
			Result := maximum >= element
		end

	max (list: ARRAY [G]): G
		require
			not_empty: not list.is_empty
		do
			Result := list [list.lower]
			across
				list as i
			loop
				Result := i.item.max (Result)
			end
		ensure
			is_part_of_array: list.has (Result)
			is_maximum: list.for_all (agent is_max(?, Result))
		end

feature -- Initialization

	make
		do
		end

	greatest_element (a: ARRAY [G]): G
		do
			Result := max (a)
		end

end
