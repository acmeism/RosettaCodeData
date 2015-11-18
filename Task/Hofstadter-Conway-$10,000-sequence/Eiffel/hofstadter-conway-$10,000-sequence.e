class
	APPLICATION

create
	make

feature

	make
			--Tests the feature sequence.
		local
			j, n, exp: INTEGER
			max: REAL_64
		do
			exp := 15
			n := (2 ^ exp).floor
			sequence (n)
			across
				1 |..| (exp - 1) as c
			loop
				max := 0
				from
					j := (2 ^ c.item).floor
				until
					j > 2 ^ (c.item + 1)
				loop
					if members [j] / j > max then
						max := members [j] / j
					end
					j := j + 1
				end
				io.put_string ("Between 2^" + c.item.out + "and 2^" + (c.item + 1).out + " the max is: " + max.out)
				io.new_line
			end
		end

feature {NONE}

	members: LINKED_LIST [INTEGER]
			-- Members of the Hofstadter Conway $10000 sequence.

	sequence (n: INTEGER)
			-- Hofstadter Conway $10000 sequence up to 'n' in 'members'.
		require
			n_positive: n > 0
		local
			last: INTEGER
		do
			create members.make
			members.extend (1)
			members.extend (1)
			across
				3 |..| n as c
			loop
				last := members.last
				members.extend (members [last] + members [c.item - last])
			end
		end

end
