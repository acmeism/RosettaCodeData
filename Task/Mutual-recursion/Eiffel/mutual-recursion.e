class
	APPLICATION

create
	make

feature

	make
			-- Test of the mutually recursive functions Female and Male.
		do
			across
				0 |..| 19 as c
			loop
				io.put_string (Female (c.item).out + " ")
			end
			io.new_line
			across
				0 |..| 19 as c
			loop
				io.put_string (Male (c.item).out + " ")
			end
		end

	Female (n: INTEGER): INTEGER
			-- Female sequence of the Hofstadter Female and Male sequences.
		require
			n_not_negative: n >= 0
		do
			Result := 1
			if n /= 0 then
				Result := n - Male (Female (n - 1))
			end
		end

	Male (n: INTEGER): INTEGER
			-- Male sequence of the Hofstadter Female and Male sequences.
		require
			n_not_negative: n >= 0
		do
			Result := 0
			if n /= 0 then
				Result := n - Female (Male (n - 1))
			end
		end

end
