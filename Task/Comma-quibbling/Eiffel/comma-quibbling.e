class
	APPLICATION

create
	make

feature

		make
			-- Test of the feature comma_quibbling.
		local
			l: LINKED_LIST [STRING]
		do
			create l.make
			io.put_string (comma_quibbling (l) + "%N")
			l.extend ("ABC")
			io.put_string (comma_quibbling (l) + "%N")
			l.extend ("DEF")
			io.put_string (comma_quibbling (l) + "%N")
			l.extend ("G")
			l.extend ("H")
			io.put_string (comma_quibbling (l) + "%N")
		end

	comma_quibbling (l: LINKED_LIST [STRING]): STRING
			-- Elements of 'l' seperated by a comma or an and where appropriate.
		require
			l_not_void: l /= Void
		do
			create Result.make_empty
			Result.extend ('{')
			if l.is_empty then
				Result.append ("}")
			elseif l.count = 1 then
				Result.append (l [1] + "}")
			else
				Result.append (l [1])
				across
					2 |..| (l.count - 1) as c
				loop
					Result.append (", " + l [c.item])
				end
				Result.append (" and " + l [l.count] + "}")
			end
		end

end
