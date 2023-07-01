class
	APPLICATION

create
	make

feature

	prod, sum, x, y, z, one, three, seven: INTEGER

	make
		local
			process: PROCEDURE
		do
			prod := 1; x := 5; y := -5; z := -2; one := 1; three := 3; seven := 7
			process := (agent (j: INTEGER)
								do
									print (j.out + ", ")
									sum := sum + j.abs
									if prod.abs < 2^27 and j /= 0 then
										prod := prod * j
									end
								end)

			across (-three |..| (3^3).truncated_to_integer).new_cursor + (three - 1)  as ic loop process.call (ic.item) end
			across (-seven |..| seven).new_cursor + (x - 1)	as ic loop process.call (ic.item) end
			across 555 |..| (550 - y) as ic loop process.call (ic.item) end
			across (-26 |..| 22).new_cursor + (three - 1) as ic loop process.call (ic.item) end
			across 1927 |..| 1939 as ic loop process.call (ic.item) end
			across (y |..| x).new_cursor + (-z - 1)	as ic loop process.call (ic.item) end
			across (11^x).truncated_to_integer |..| ((11^x).truncated_to_integer + 1) as ic loop process.call (ic.item) end

			print ("%N")
			print ("sum = " + sum.out + "%N") 		-- sum = 348,173
			print ("prod = " + prod.out + "%N")		-- prod = -793,618,560
		end

end
