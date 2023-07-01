class
	APPLICATION

create
	make

feature

	make
		do
			sequence_of_non_squares (22)
			io.new_line
			sequence_of_non_squares (1000000)
		end

	sequence_of_non_squares (n: INTEGER)
                        -- Sequence of non-squares up to the n'th member.
		require
			n_positive: n >= 1
		local
			non_sq, part: REAL_64
			math: DOUBLE_MATH
			square: BOOLEAN
		do
			create math
			across
				1 |..| (n) as c
			loop
				part := (0.5 + math.sqrt (c.item.to_double))
				non_sq := c.item + part.floor
				io.put_string (non_sq.out + "%N")
				if math.sqrt (non_sq) - math.sqrt (non_sq).floor = 0 then
					square := True
				end
			end
			if square = True then
				io.put_string ("There are squares for n equal to " + n.out + ".")
			else
				io.put_string ("There are no squares for n equal to " + n.out + ".")
			end
		end

end
