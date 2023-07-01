class
	APPLICATION

create
	make

feature

	make
			-- Test the feature proper_divisors.
		local
			list: LINKED_LIST [INTEGER]
			count, number: INTEGER
		do
			across
				1 |..| 10 as c
			loop
				list := proper_divisors (c.item)
				io.put_string (c.item.out + ": ")
				across
					list as l
				loop
					io.put_string (l.item.out + " ")
				end
				io.new_line
			end
			across
				1 |..| 20000 as c
			loop
				list := proper_divisors (c.item)
				if list.count > count then
					count := list.count
					number := c.item
				end
			end
			io.put_string (number.out + " has with " + count.out + " divisors the highest number of proper divisors.")
		end

	proper_divisors (n: INTEGER): LINKED_LIST [INTEGER]
			-- Proper divisors of 'n'.
		do
			create Result.make
			across
				1 |..| (n - 1) as c
			loop
				if n \\ c.item = 0 then
					Result.extend (c.item)
				end
			end
		end

end
