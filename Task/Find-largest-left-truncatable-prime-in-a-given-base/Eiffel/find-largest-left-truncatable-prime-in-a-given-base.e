class
	LARGEST_LEFT_TRUNCABLE_PRIME

create
	make

feature

	make
			-- Tests find_prime for different bases.
		local
			i: INTEGER
			decimal: INTEGER_64
		do
			from
				i := 3
			until
				i = 10
			loop
				largest := 0
				find_prime ("", i)
				decimal := convert_to_decimal (largest, i)
				io.put_string (i.out + ":%T" + decimal.out)
				io.new_line
				i := i + 1
			end
		end

	find_prime (right_part: STRING; base: INTEGER)
			-- Largest left truncable prime for a given 'base'.
		local
			i, larger, larger_dec: INTEGER_64
			right: STRING
			prime: BOOLEAN
		do
			from
				i := 1
			until
				i = base
			loop
				create right.make_empty
				right.deep_copy (right_part)
				right.prepend (i.out)
				larger := right.to_integer_64
				if base /= 10 then
					larger_dec := convert_to_decimal (larger, base)
					if larger_dec < 0 then
						io.put_string ("overflow")
						prime := False
					else
						prime := is_prime (larger_dec)
					end
				else
					prime := is_prime (larger)
				end
				if prime = TRUE then
					find_prime (larger.out, base)
				else
					if right_part.count > 0 and right_part.to_integer_64 > largest then
						largest := right_part.to_integer_64
					end
				end
				i := i + 1
			end
		end

	largest: INTEGER_64

	convert_to_decimal (given, base: INTEGER_64): INTEGER_64
			-- 'given' converted to base ten.
		require
		local
			n, i: INTEGER
			st_digits: STRING
			dec: REAL_64
		do
			n := given.out.count
			dec := 0
			st_digits := given.out
			from
				i := 1
			until
				n < 0 or i > given.out.count
			loop
				n := n - 1
				dec := dec + st_digits.at (i).out.to_integer * base ^ n
				i := i + 1
			end
			Result := dec.truncated_to_integer_64
		end

	is_prime (n: INTEGER_64): BOOLEAN
			--Is 'n' a prime number?
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
