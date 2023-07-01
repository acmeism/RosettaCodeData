class
	APPLICATION

create
	make

feature

	make
		do
			sequence (1, 27)
		end

	sequence (lower, upper: INTEGER)
			-- Sequence of primes from 'lower' to 'upper'.
		require
			lower_positive: lower > 0
			upper_positive: upper > 0
			lower_smaller: lower < upper
		local
			i: INTEGER
		do
			io.put_string ("Sequence of primes from " + lower.out + " up to " + upper.out + ".%N")
			i := lower
			if i \\ 2 = 0 then
				i := i + 1
			end
			from
			until
				i > upper
			loop
				if is_prime (i) then
					io.put_integer (i)
					io.put_new_line
				end
				i := i + 2
			end
		end

feature {NONE}

	is_prime (n: INTEGER): BOOLEAN
			-- Is 'n' a prime number?
		require
			positiv_input: n > 0
		local
			i: INTEGER
			max: REAL_64
			math: DOUBLE_MATH
		do
			create math
			if n = 2 then
				Result := True
			elseif n <= 1 or n \\ 2 = 0 then
				Result := False
			else
				Result := True
				max := math.sqrt (n)
				from
					i := 3
				until
					i > max
				loop
					if n \\ i = 0 then
						Result := False
					end
					i := i + 2
				end
			end
		end

end
