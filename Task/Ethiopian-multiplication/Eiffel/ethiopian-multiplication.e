class
	APPLICATION

create
	make

feature {NONE}

	make
		do
			io.put_integer (ethiopian_multiplication (17, 34))
		end

	ethiopian_multiplication (a, b: INTEGER): INTEGER
			-- Product of 'a' and 'b'.
		require
			a_positive: a > 0
			b_positive: b > 0
		local
			x, y: INTEGER
		do
			x := a
			y := b
			from
			until
				x <= 0
			loop
				if not is_even_int (x) then
					Result := Result + y
				end
				x := halve_int (x)
				y := double_int (y)
			end
		ensure
			Result_correct: Result = a * b
		end

feature {NONE}

	double_int (n: INTEGER): INTEGER
                        --Two times 'n'.
		do
			Result := n * 2
		end

	halve_int (n: INTEGER): INTEGER
                        --'n' divided by two.
		do
			Result := n // 2
		end

	is_even_int (n: INTEGER): BOOLEAN
                        --Is 'n' an even integer?
		do
			Result := n \\ 2 = 0
		end

end
