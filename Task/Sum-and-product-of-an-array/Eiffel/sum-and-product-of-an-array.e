note
	description : "project application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE}

	array : ARRAY[INTEGER]

	make
		do
			create array.make_filled (0, 0, 4)
			array.put (2, 0)
			array.put (4, 1)
			array.put (6, 2)
			array.put (8, 3)
			array.put (10, 4)

			print("%NSum of the elements of the array: ")
			print(sum(array))
			print("%NProduct of the elements of the array: ")
			print(product(array))
		end

	sum(ar : ARRAY[INTEGER]):INTEGER
		local
			s, i: INTEGER
		do
			from
				i := 0
			until
				i > 4
			loop
				s := s + ar[i]
				i := i + 1
			end
			Result := s
		end

	product(ar : ARRAY [INTEGER]):INTEGER
		local
			prod, i: INTEGER
		do
			prod := 1
			from
				i := 0
			until
				i > 4
			loop
				prod := prod * ar[i]
				i := i + 1
			end
			Result := prod
		end
end
