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

			⟳ ic: (-three |..| (3^3).truncated_to_integer).new_cursor + (three - 1) ¦ process.call (ic) ⟲
			⟳ ic: (-seven |..| seven).new_cursor + (x - 1) ¦ process.call (ic) ⟲
			⟳ ic:555 |..| (550 - y) ¦ process.call (ic) ⟲
			⟳ ic: (-26 |..| 22).new_cursor + (three - 1) ¦ process.call (ic) ⟲
			⟳ ic: 1927 |..| 1939 ¦ process.call (ic) ⟲
			⟳ ic: (y |..| x).new_cursor + (-z - 1) ¦ process.call (ic) ⟲
			⟳ ic: (11^x).truncated_to_integer |..| ((11^x).truncated_to_integer + 1) ¦ process.call (ic) ⟲

			print ("%N")
			print ("sum = " + sum.out + "%N") 		-- sum = 348,173
			print ("prod = " + prod.out + "%N")		-- prod = -793,618,560
		end

end
