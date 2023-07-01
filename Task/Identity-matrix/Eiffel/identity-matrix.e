class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
		    dim : INTEGER -- Dimension of the identity matrix
		do
		    from dim := 1 until dim > 10 loop
		    	print_matrix( identity_matrix(dim) )
				dim := dim + 1
				io.new_line
			end

		end

feature -- Access

	identity_matrix(dim : INTEGER) : ARRAY2[REAL_64]

		require
			dim > 0
		local
			matrix : ARRAY2[REAL_64]
			i : INTEGER
		do

			create matrix.make_filled (0.0, dim, dim)
			from i := 1 until i > dim loop
				matrix.put(1.0, i, i)
				i := i + 1
			end

			Result := matrix
		end

	print_matrix(matrix : ARRAY2[REAL_64])
		local
			i, j : INTEGER
		do
			from i := 1 until i > matrix.height loop
				print("[ ")
				from j := 1 until j > matrix.width loop
					print(matrix.item (i, j))
					print(" ")
					j := j + 1
				end
				print("]%N")
				i := i + 1
			end
		end

end
