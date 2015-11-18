	make
			-- Run application.
		note
			synopsis: "[
				The specification implies command line input stream and also
				implies a range for both `A' and `B' (e.g. (-1000 <= A,B <= +1000)).
				To test in Eiffel Studio workbench, one can set Execution Parameters
				of "2 2", where the expected output is 4. One may also create other
				test Execution Parameters where the inputs are out-of-bounds and
				confirm the failure.
				]"
		do
			if attached {INTEGER} argument (1).to_integer as a and then
				attached {INTEGER} argument (2).to_integer as b and then
				(a >= -1000 and b >= -1000 and a <= 1000 and b <= 1000) then
				print (a + b)
			else
				print ("Either argument 1 or 2 is out-of-bounds. Ensure: (-1000 <= A,B <= +1000)")
			end
		end
