class
	APPLICATION

create
	make

feature

	make
		local
			perimeter: INTEGER
		do
			perimeter := 100
			from
			until
				perimeter > 1000000
			loop
				total := 0
				primitive_triples := 0
				count_pythagorean_triples (3, 4, 5, perimeter)
				io.put_string ("There are " + total.out + " triples, below " + perimeter.out + ". Of which " + primitive_triples.out + " are primitives.%N")
				perimeter := perimeter * 10
			end
		end

	count_pythagorean_triples (a, b, c, perimeter: INTEGER)
			-- Total count of pythagorean triples and total count of primitve triples below perimeter.
		local
			p: INTEGER
		do
			p := a + b + c
			if p <= perimeter then
				primitive_triples := primitive_triples + 1
				total := total + perimeter // p
				count_pythagorean_triples (a + 2 * (- b + c), 2 * (a + c) - b, 2 * (a - b + c) + c, perimeter)
				count_pythagorean_triples (a + 2 * (b + c), 2 * (a + c) + b, 2 * (a + b + c) + c, perimeter)
				count_pythagorean_triples (- a + 2 * (b + c), 2 * (- a + c) + b, 2 * (- a + b + c) + c, perimeter)
			end
		end

feature {NONE}

	primitive_triples: INTEGER

	total: INTEGER

end
