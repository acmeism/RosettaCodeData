class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_val: INTEGER
		do
			from
				l_val := 1
			until
				l_val > 100
			loop
				if is_happy_number (l_val) then
					print (l_val.out)
					print ("%N")
				end
				l_val := l_val + 1
			end
		end

feature -- Happy number

	is_happy_number (a_number: INTEGER): BOOLEAN
			-- Is `a_number' a happy number?
		require
			positive_number: a_number > 0
		local
			l_number: INTEGER
			l_set: ARRAYED_SET [INTEGER]
		do
			from
				l_number := a_number
				create l_set.make (10)
			until
				l_number = 1 or l_set.has (l_number)
			loop
				l_set.put (l_number)
				l_number := square_sum_of_digits (l_number)
			end

			Result := (l_number = 1)
		end

feature{NONE} -- Implementation

	square_sum_of_digits (a_number: INTEGER): INTEGER
			-- Sum of the sqares of digits of `a_number'.
		require
			positive_number: a_number > 0
		local
			l_number, l_digit: INTEGER
		do
			from
				l_number := a_number
			until
				l_number = 0
			loop
				l_digit := l_number \\ 10
				Result := Result + l_digit * l_digit
				l_number := l_number // 10
			end
		end

end
