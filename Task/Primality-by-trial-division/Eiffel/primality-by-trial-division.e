class
	APPLICATION

create
	make

feature

	make
                -- Tests the feature is_prime.
		do
			io.put_boolean (is_prime (1))
			io.new_line
			io.put_boolean (is_prime (2))
			io.new_line
			io.put_boolean (is_prime (3))
			io.new_line
			io.put_boolean (is_prime (4))
			io.new_line
			io.put_boolean (is_prime (97))
			io.new_line
			io.put_boolean (is_prime (15589))
			io.new_line
		end

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
