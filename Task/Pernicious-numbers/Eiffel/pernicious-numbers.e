class
	APPLICATION

create
	make

feature

	make
			-- Test of is_pernicious_number.
		local
			test: LINKED_LIST [INTEGER]
			i: INTEGER
		do
			create test.make
			from
				i := 1
			until
				test.count = 25
			loop
				if is_pernicious_number (i) then
					test.extend (i)
				end
				i := i + 1
			end
			across
				test as t
			loop
				io.put_string (t.item.out + " ")
			end
			io.new_line
			across
				888888877 |..| 888888888 as c
			loop
				if is_pernicious_number (c.item) then
					io.put_string (c.item.out + " ")
				end
			end
		end

	is_pernicious_number (n: INTEGER): BOOLEAN
			-- Is 'n' a pernicious_number?
		require
			positiv_input: n > 0
		do
			Result := is_prime (count_population (n))
		end

feature{NONE}

	count_population (n: INTEGER): INTEGER
			-- Population count of 'n'.
		require
			positiv_input: n > 0
		local
			j: INTEGER
			math: DOUBLE_MATH
		do
			create math
			j := math.log_2 (n).ceiling + 1
			across
				0 |..| j as c
			loop
				if n.bit_test (c.item) then
					Result := Result + 1
				end
			end
		end

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

end
