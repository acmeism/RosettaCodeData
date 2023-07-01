class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			print(dot_product(<<1, 3, -5>>, <<4, -2, -1>>).out)
		end

feature -- Access

	dot_product (a, b: ARRAY[INTEGER]): INTEGER
			-- Dot product of vectors `a' and `b'.
		require
			a.lower = b.lower
			a.upper = b.upper
		local
			i: INTEGER
		do
			from
				i := a.lower
			until
				i > a.upper
			loop
				Result := Result + a[i] * b[i]
				i := i + 1
			end
		end
end
