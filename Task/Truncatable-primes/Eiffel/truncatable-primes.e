class
	APPLICATION

create
	make

feature

	make
		do
			io.put_string ("Largest right truncatable prime: " + find_right_truncatable_primes.out)
			io.new_line
			io.put_string ("Largest left truncatable prime: " + find_left_truncatable_primes.out)
		end

	find_right_truncatable_primes: INTEGER
			-- Largest right truncatable prime below 1000000.
		local
			i, maybe_prime: INTEGER
			found, is_one: BOOLEAN
		do
			from
				i := 999999
			until
				found
			loop
				is_one := True
				from
					maybe_prime := i
				until
					not is_one  or maybe_prime.out.count = 1
				loop
					if maybe_prime.out.has ('0') or maybe_prime.out.has ('2') or maybe_prime.out.has ('4') or maybe_prime.out.has ('6') or maybe_prime.out.has ('8') then
						is_one := False
					else
						if not is_prime (maybe_prime)  then
							is_one := False
						elseif is_prime (maybe_prime) and maybe_prime.out.count > 1 then
							maybe_prime := truncate_right (maybe_prime)
						end
					end
				end
				if is_one then
					found := True
					Result := i
				end
				i := i - 2
			end
		ensure
			Result_is_smaller: Result < 1000000
		end

	find_left_truncatable_primes: INTEGER
			-- Largest left truncatable prime below 1000000.
		local
			i, maybe_prime: INTEGER
			found, is_one: BOOLEAN
		do
			from
				i := 999999
			until
				found
			loop
				is_one := True
				from
					maybe_prime := i
				until
					not is_one or maybe_prime.out.count = 1
				loop
					if not is_prime (maybe_prime) then
						is_one := False
					elseif is_prime (maybe_prime) and maybe_prime.out.count > 1 then
						if maybe_prime.out.at (2) = '0' then
							is_one := False
						else
							maybe_prime := truncate_left (maybe_prime)
						end
					end
				end
				if is_one then
					found := True
					Result := i
				end
				i := i - 2
			end
		ensure
			Result_is_smaller: Result < 1000000
		end

feature {NONE}

	is_prime (n: INTEGER): BOOLEAN
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

	truncate_left (n: INTEGER): INTEGER
			-- 'n' truncated by one digit from the left side.
		require
			truncatable: n.out.count > 1
		local
			st: STRING
		do
			st := n.out
			st.remove_head (1)
			Result := st.to_integer
		ensure
			Result_truncated: Result.out.count = n.out.count - 1
		end

	truncate_right (n: INTEGER): INTEGER
			-- 'n' truncated by one digit from the right side.
		require
			truncatable: n.out.count > 1
		local
			st: STRING
		do
			st := n.out
			st.remove_tail (1)
			Result := st.to_integer
		ensure
			Result_truncated: Result.out.count = n.out.count - 1
		end

end
