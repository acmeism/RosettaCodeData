class
	APPLICATION

create
	make

feature {NONE}

	make
		do
			io.put_integer (sum_multiples (1000))
		end

	sum_multiples (n: INTEGER): INTEGER
			-- Sum of all positive multiples of 3 or 5 below 'n'.
		do
			across
				1 |..| (n - 1) as c
			loop
				if c.item \\ 3 = 0 or c.item \\ 5 = 0 then
					Result := Result + c.item
				end
			end
		end

end
