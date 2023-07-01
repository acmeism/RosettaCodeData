class
	APPLICATION

create
	make

feature {NONE}

	make
		local
			test: ARRAY [INTEGER]
		do
			create test.make_empty
			test := <<5, 1, 9, 7>>
			io.put_string ("Sum: " + sum (test).out)
			io.new_line
			io.put_string ("Product: " + product (test).out)
		end

	sum (ar: ARRAY [INTEGER]): INTEGER
			-- Sum of the items of the array 'ar'.
		do
			across
				ar.lower |..| ar.upper as c
			loop
				Result := Result + ar [c.item]
			end
		end

	product (ar: ARRAY [INTEGER]): INTEGER
			-- Product of the items of the array 'ar'.
		do
			Result := 1
			across
				ar.lower |..| ar.upper as c
			loop
				Result := Result * ar [c.item]
			end
		end

end
